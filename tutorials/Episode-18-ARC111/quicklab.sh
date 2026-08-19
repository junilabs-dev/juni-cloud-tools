#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting ARC111 - Implement Cloud Storage and Data Protection Solutions: Challenge Lab..."

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

print_info "====================================================="
print_info "PLEASE ENTER THE BUCKET NAMES FROM YOUR QWIKLABS PANEL"
print_info "====================================================="
read -p "Enter Bucket 1 Name (for creation): " BUCKET_1
read -p "Enter Bucket 2 Name (for retention policy): " BUCKET_2
read -p "Enter Bucket 3 Name (for uploading object): " BUCKET_3

if [ -z "$BUCKET_1" ] || [ -z "$BUCKET_2" ] || [ -z "$BUCKET_3" ]; then
    error "Bucket names cannot be empty. Please run the script again and provide the names."
    exit 1
fi

print_info "🚀 Task 1: Creating Bucket 1 ($BUCKET_1) with Coldline Storage class..."
gcloud storage buckets create gs://$BUCKET_1 --location=$REGION --default-storage-class=COLDLINE

print_info "⏳ Task 2: Adding 30s retention policy to Bucket 2 ($BUCKET_2)..."
gcloud storage buckets update gs://$BUCKET_2 --retention-period=30s

print_info "🖼️ Task 3: Adding an object to Bucket 3 ($BUCKET_3)..."
echo "Dummy file for ARC111 Challenge Lab" > dummy_file.txt
gcloud storage cp dummy_file.txt gs://$BUCKET_3/
rm dummy_file.txt

success "🎉 Lab ARC111 Challenge Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
