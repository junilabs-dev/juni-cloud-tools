#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP647 - Configuring IAM Permissions with gcloud..."

export PROJECT_ID_1=$(gcloud config get-value project)
if [ -z "$PROJECT_ID_1" ]; then
    error "PROJECT_ID_1 is not set in Cloud Shell."
    read -p "Please enter your Qwiklabs PROJECT_ID 1: " PROJECT_ID_1
    gcloud config set project $PROJECT_ID_1
fi

echo ""
print_info "Please check your Qwiklabs lab panel for the following details:"
read -p "Enter Project ID 2: " PROJECT_ID_2
read -p "Enter Username 2: " USER_2

# 1. Create lab-1 in Project 1
print_info "🚀 Creating lab-1 in $PROJECT_ID_1..."
gcloud compute instances create lab-1 --project=$PROJECT_ID_1 --zone=europe-west1-b --machine-type=e2-standard-2 --quiet || true

# 2. Add viewer role to USER_2 in Project 2
print_info "🚀 Assigning viewer role to $USER_2 in $PROJECT_ID_2..."
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=roles/viewer --quiet || true

# 3. Create devops custom role in Project 2
print_info "🚀 Creating custom role 'devops' in $PROJECT_ID_2..."
gcloud iam roles create devops --project $PROJECT_ID_2 \
    --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount" \
    --quiet || true

# 4. Bind devops and iam.serviceAccountUser roles to USER_2 in Project 2
print_info "🚀 Binding roles to $USER_2 in $PROJECT_ID_2..."
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=roles/iam.serviceAccountUser --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=projects/$PROJECT_ID_2/roles/devops --quiet || true

# 5. Create lab-2 in Project 2
print_info "🚀 Creating lab-2 in $PROJECT_ID_2..."
gcloud compute instances create lab-2 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --quiet || true

# 6. Create devops service account in Project 2
print_info "🚀 Creating devops service account in $PROJECT_ID_2..."
gcloud iam service-accounts create devops --display-name devops --project $PROJECT_ID_2 --quiet || true
SA="devops@${PROJECT_ID_2}.iam.gserviceaccount.com"

# Wait a few seconds for the SA to propagate
sleep 5

# 7. Bind roles to the devops service account
print_info "🚀 Binding roles to devops service account..."
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=serviceAccount:$SA --role=roles/iam.serviceAccountUser --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=serviceAccount:$SA --role=roles/compute.instanceAdmin --quiet || true

# 8. Create lab-3 with service account
print_info "🚀 Creating lab-3 in $PROJECT_ID_2 with devops service account..."
gcloud compute instances create lab-3 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --service-account=$SA --scopes="https://www.googleapis.com/auth/compute" --quiet || true

# 9. Create lab-4
print_info "🚀 Creating lab-4 in $PROJECT_ID_2..."
gcloud compute instances create lab-4 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --quiet || true

success "🎉 Lab GSP647 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
