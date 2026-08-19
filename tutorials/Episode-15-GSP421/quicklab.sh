#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP421 - APIs Explorer: Cloud Storage..."

export PROJECT_ID=$(gcloud config get-value project)
BUCKET_1="${PROJECT_ID}-bucket01"
BUCKET_2="${PROJECT_ID}-bucket02"

print_info "🚀 Task 1: Creating first Cloud Storage bucket ($BUCKET_1)..."
gsutil mb gs://$BUCKET_1/

print_info "🚀 Task 2: Creating second Cloud Storage bucket ($BUCKET_2)..."
gsutil mb gs://$BUCKET_2/

print_info "🖼️ Task 3: Uploading files to the first bucket..."
# Downloading dummy images
curl -sL "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png" > demo-image1.png
curl -sL "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png" > demo-image2.png
# Upload to Bucket 1
gsutil cp demo-image1.png gs://$BUCKET_1/
gsutil cp demo-image2.png gs://$BUCKET_1/

print_info "📋 Task 4: Copying file from Bucket 1 to Bucket 2..."
gsutil cp gs://$BUCKET_1/demo-image1.png gs://$BUCKET_2/demo-image1-copy.png

print_info "====================================================="
print_info "🛑 STOP HERE! Go to Qwiklabs and click 'Check my progress'"
print_info "for the first 4 tasks. Ensure you get 75/100 points."
print_info "====================================================="
read -p "Press [Enter] after you have verified the points to continue..."

print_info "🗑️ Task 5: Deleting files from the first bucket..."
gsutil rm gs://$BUCKET_1/demo-image1.png
gsutil rm gs://$BUCKET_1/demo-image2.png

print_info "🔥 Task 6: Deleting the first Cloud Storage bucket..."
gsutil rb gs://$BUCKET_1/

success "🎉 Lab GSP421 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
