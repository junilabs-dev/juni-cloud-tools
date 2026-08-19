#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP074 - Cloud Storage: Qwik Start - CLI/SDK..."

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get compute/region 2>/dev/null)

if [ -z "$REGION" ]; then
    # Fallback to us-central1 if region is not set in config
    REGION="us-central1"
fi

BUCKET_NAME="${PROJECT_ID}-bucket"

print_info "🚀 Task 1: Creating a Cloud Storage bucket ($BUCKET_NAME)..."
gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION

print_info "🖼️ Task 2: Uploading an object into your bucket..."
curl -sL https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg
gcloud storage cp ada.jpg gs://$BUCKET_NAME
rm ada.jpg

print_info "⬇️ Task 3: Downloading an object from your bucket..."
gcloud storage cp -r gs://$BUCKET_NAME/ada.jpg .

print_info "📁 Task 4: Copying an object to a folder in the bucket..."
gcloud storage cp gs://$BUCKET_NAME/ada.jpg gs://$BUCKET_NAME/image-folder/

print_info "🔍 Task 5 & 6: Listing contents and details..."
gcloud storage ls gs://$BUCKET_NAME
gcloud storage ls -l gs://$BUCKET_NAME/ada.jpg

print_info "🌍 Task 7: Making your object publicly accessible..."
gcloud storage objects update gs://$BUCKET_NAME/ada.jpg --add-acl-grant=entity=allUsers,role=READER

print_info "====================================================="
print_info "🛑 STOP HERE! Go to Qwiklabs and click 'Check my progress'"
print_info "for all the tasks. Ensure you get 100/100 points."
print_info "====================================================="
read -p "Press [Enter] after you have verified the points to finish the cleanup..."

print_info "🔒 Task 8: Removing public access..."
gcloud storage objects update gs://$BUCKET_NAME/ada.jpg --remove-acl-grant=allUsers

print_info "🗑️ Task 9: Deleting objects..."
gcloud storage rm gs://$BUCKET_NAME/ada.jpg

success "🎉 Lab GSP074 Setup Complete!"
