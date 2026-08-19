#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP073 - Cloud Storage: Qwik Start - Google Cloud Console..."

export PROJECT_ID=$(gcloud config get-value project)
# Try to get region from config, then from project metadata
export REGION=$(gcloud config get compute/region 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
fi

if [ -z "$REGION" ]; then
    error "Could not automatically detect the region."
    read -p "Please enter the REGION from your Qwiklabs panel (e.g. us-east1): " REGION
fi

print_info "Using REGION: $REGION"

BUCKET_NAME=$PROJECT_ID

print_info "🚀 Task 1: Creating a Cloud Storage bucket ($BUCKET_NAME)..."
# Create the bucket with Uniform Access Control
gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION --uniform-bucket-level-access
# Ensure public access prevention is disabled
gcloud storage buckets update gs://$BUCKET_NAME --no-public-access-prevention

print_info "🖼️ Task 2: Uploading an object into the bucket (kitten.png)..."
curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Kitten_in_Rizal_Park%2C_Manila.jpg/800px-Kitten_in_Rizal_Park%2C_Manila.jpg" -o kitten.png
gcloud storage cp kitten.png gs://$BUCKET_NAME/

print_info "🌍 Task 3: Sharing the bucket publicly..."
# Grant allUsers the Storage Object Viewer role
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member=allUsers --role=roles/storage.objectViewer

print_info "📁 Task 4: Creating folders..."
# Copy the same image into a subfolder to satisfy Task 4
gcloud storage cp kitten.png gs://$BUCKET_NAME/folder1/folder2/kitten.png

print_info "====================================================="
print_info "🛑 STOP HERE! Go to Qwiklabs and click 'Check my progress'"
print_info "for all the tasks. Ensure you get 100/100 points."
print_info "====================================================="
read -p "Press [Enter] after you have verified the points to finish the cleanup..."

print_info "🗑️ Task 5: Deleting a folder..."
gcloud storage rm -r gs://$BUCKET_NAME/folder1

success "🎉 Lab GSP073 Setup Complete!"
