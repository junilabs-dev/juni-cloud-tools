#!/bin/bash
set -euo pipefail

source ./utils.sh
print_banner
print_info "Starting Service Account Creator..."

SA_NAME="juni-automation-sa"
SA_DISPLAY_NAME="JuniLabs Automation Service Account"

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")

print_info "Creating Service Account: ${SA_NAME}..."
gcloud iam service-accounts create "$SA_NAME" \
    --display-name="$SA_DISPLAY_NAME" || warning "SA might already exist."

SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

print_info "Assigning Roles..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/editor" >/dev/null

success "🎉 Service Account ${BOLD}${SA_EMAIL}${NC} is ready!"
