#!/bin/bash
set -euo pipefail

source ./utils.sh
print_banner
print_info "Starting Storage Bucket Creator..."

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
BUCKET_NAME="${PROJECT_ID}-juni-bucket"
REGION="us-central1"

print_info "Creating bucket: gs://${BUCKET_NAME} in ${REGION}..."
gcloud storage buckets create "gs://${BUCKET_NAME}" \
    --location="$REGION" \
    --default-storage-class="STANDARD" \
    --uniform-bucket-level-access || warning "Bucket might already exist or name is taken."

success "🎉 Bucket gs://${BUCKET_NAME} is ready!"
