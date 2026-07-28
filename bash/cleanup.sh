#!/bin/bash
set -euo pipefail

source ./utils.sh
print_banner
warning "Starting Cleanup Script... This will delete resources!"

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
VM_NAME="juni-dev-instance"
ZONE="us-central1-a"
BUCKET_NAME="${PROJECT_ID}-juni-bucket"

print_info "Deleting VM: ${VM_NAME}..."
gcloud compute instances delete "$VM_NAME" --zone="$ZONE" --quiet || warning "VM not found or already deleted."

print_info "Deleting Storage Bucket: gs://${BUCKET_NAME}..."
gcloud storage rm --recursive "gs://${BUCKET_NAME}" || warning "Bucket not found or already deleted."

success "🎉 Cleanup Completed!"
