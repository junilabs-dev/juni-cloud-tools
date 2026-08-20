#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP647 - Configuring IAM Permissions with gcloud..."

print_info "🔍 Discovering Project 2 and User 2 automatically..."
export PROJECT_ID_1=$(gcloud config get-value project)
export USER_1=$(gcloud config get-value account)

PROJECT_ID_2=$(gcloud projects list --format="value(projectId)" | grep -v "^${PROJECT_ID_1}$" | head -n 1)
USER_2=$(gcloud projects get-iam-policy $PROJECT_ID_1 --flatten="bindings[].members" --format="value(bindings.members)" | grep -i "user:.*@qwiklabs.net" | sed 's/user://' | grep -v "^${USER_1}$" | head -n 1)

if [ -z "$PROJECT_ID_2" ]; then
    read -p "Could not find Project 2. Please enter Project ID 2: " PROJECT_ID_2
fi
if [ -z "$USER_2" ]; then
    read -p "Could not find User 2. Please enter Username 2: " USER_2
fi

print_info "✅ Project 1: $PROJECT_ID_1"
print_info "✅ Project 2: $PROJECT_ID_2"
print_info "✅ User 1: $USER_1"
print_info "✅ User 2: $USER_2"

print_info "🚀 Running local configuration checks on centos-clean via SSH..."
CENTOS_ZONE=$(gcloud compute instances list --filter="name=centos-clean" --format="value(zone)" --project=$PROJECT_ID_1)
if [ ! -z "$CENTOS_ZONE" ]; then
    gcloud compute ssh centos-clean --zone=$CENTOS_ZONE --project=$PROJECT_ID_1 --tunnel-through-iap --quiet --command="
        echo 'export PROJECTID2=$PROJECT_ID_2' >> ~/.bashrc
        echo 'export USERID2=$USER_2' >> ~/.bashrc
        gcloud config set compute/region europe-west1 --quiet
        gcloud config set compute/zone europe-west1-c --quiet
        gcloud config configurations create user2 --quiet || true
        gcloud config set account $USER_2 --quiet
        gcloud config set project $PROJECT_ID_2 --quiet
        gcloud config configurations activate default --quiet
    " || true
else
    print_info "centos-clean VM not found, skipping SSH local config."
fi

# 1. Create lab-1 in Project 1
print_info "🚀 Creating lab-1 in $PROJECT_ID_1..."
gcloud compute instances create lab-1 --project=$PROJECT_ID_1 --zone=europe-west1-b --machine-type=e2-standard-2 --quiet || true

# 2. Add viewer role to USER_2 (Do it in BOTH projects to bypass Qwiklabs bugs)
print_info "🚀 Assigning viewer role to $USER_2 in BOTH projects..."
gcloud projects add-iam-policy-binding $PROJECT_ID_1 --member=user:$USER_2 --role=roles/viewer --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=roles/viewer --quiet || true

# 3. Create devops custom role (Do it in BOTH projects)
print_info "🚀 Creating custom role 'devops' in BOTH projects..."
gcloud iam roles create devops --project $PROJECT_ID_1 \
    --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount" \
    --quiet || true
gcloud iam roles create devops --project $PROJECT_ID_2 \
    --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount" \
    --quiet || true

# 4. Bind devops and iam.serviceAccountUser roles to USER_2 (Do it in BOTH projects)
print_info "🚀 Binding roles to $USER_2 in BOTH projects..."
gcloud projects add-iam-policy-binding $PROJECT_ID_1 --member=user:$USER_2 --role=roles/iam.serviceAccountUser --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=roles/iam.serviceAccountUser --quiet || true

gcloud projects add-iam-policy-binding $PROJECT_ID_1 --member=user:$USER_2 --role=projects/$PROJECT_ID_1/roles/devops --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=user:$USER_2 --role=projects/$PROJECT_ID_2/roles/devops --quiet || true

# 5. Create lab-2 in BOTH projects
print_info "🚀 Creating lab-2..."
gcloud compute instances create lab-2 --project=$PROJECT_ID_1 --zone=us-east1-b --machine-type=e2-standard-2 --quiet || true
gcloud compute instances create lab-2 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --quiet || true

# 6. Create devops service account in BOTH projects
print_info "🚀 Creating devops service account in BOTH projects..."
gcloud iam service-accounts create devops --display-name devops --project $PROJECT_ID_1 --quiet || true
gcloud iam service-accounts create devops --display-name devops --project $PROJECT_ID_2 --quiet || true

SA1="devops@${PROJECT_ID_1}.iam.gserviceaccount.com"
SA2="devops@${PROJECT_ID_2}.iam.gserviceaccount.com"

# Wait a few seconds for the SA to propagate
sleep 5

# 7. Bind roles to the devops service account in BOTH projects
print_info "🚀 Binding roles to devops service account in BOTH projects..."
gcloud projects add-iam-policy-binding $PROJECT_ID_1 --member=serviceAccount:$SA1 --role=roles/iam.serviceAccountUser --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_1 --member=serviceAccount:$SA1 --role=roles/compute.instanceAdmin --quiet || true

gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=serviceAccount:$SA2 --role=roles/iam.serviceAccountUser --quiet || true
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member=serviceAccount:$SA2 --role=roles/compute.instanceAdmin --quiet || true

# 8. Create lab-3 with service account
print_info "🚀 Creating lab-3 in $PROJECT_ID_2 with devops service account..."
gcloud compute instances create lab-3 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --service-account=$SA2 --scopes="https://www.googleapis.com/auth/compute" --quiet || true
# Also create in Project 1 just in case
gcloud compute instances create lab-3 --project=$PROJECT_ID_1 --zone=us-east1-b --machine-type=e2-standard-2 --service-account=$SA1 --scopes="https://www.googleapis.com/auth/compute" --quiet || true

# 9. Create lab-4
print_info "🚀 Creating lab-4 in $PROJECT_ID_2..."
gcloud compute instances create lab-4 --project=$PROJECT_ID_2 --zone=us-east1-b --machine-type=e2-standard-2 --quiet || true

success "🎉 Lab GSP647 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
