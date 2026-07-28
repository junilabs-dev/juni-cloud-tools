#!/bin/bash
set -euo pipefail

# Import UI Utils
source ./utils.sh

print_banner
print_info "Starting API Enabler Script..."
echo ""

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
if [ -z "$PROJECT_ID" ]; then
    error "Could not determine PROJECT_ID. Please login to gcloud."
    exit 1
fi
success "Target Project: ${BOLD}${PROJECT_ID}${NC}"
echo ""

# List of APIs to enable (You can modify this array)
APIS=(
    "compute.googleapis.com"
    "storage-component.googleapis.com"
    "iam.googleapis.com"
)

for api in "${APIS[@]}"; do
    print_info "Enabling API: $api ..."
    gcloud services enable "$api" || warning "Failed or already enabled: $api"
done

echo ""
success "🎉 All specified APIs have been enabled!"
