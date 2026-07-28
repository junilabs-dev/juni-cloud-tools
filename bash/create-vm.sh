#!/bin/bash
set -euo pipefail

source ./utils.sh
print_banner
print_info "Starting Virtual Machine Creator..."

VM_NAME="juni-dev-instance"
ZONE="us-central1-a"
MACHINE_TYPE="e2-micro"

print_info "Provisioning VM: ${VM_NAME} in ${ZONE}..."
gcloud compute instances create "$VM_NAME" \
    --zone="$ZONE" \
    --machine-type="$MACHINE_TYPE" \
    --image-family="debian-11" \
    --image-project="debian-cloud" \
    --tags="http-server,https-server" || warning "VM creation failed or already exists."

success "🎉 VM ${BOLD}${VM_NAME}${NC} is up and running!"
