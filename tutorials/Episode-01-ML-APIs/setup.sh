#!/bin/bash
set -euo pipefail

# Note the path to utils.sh since we are inside tutorials/Episode-01-ML-APIs/
source ../../bash/utils.sh

print_banner
print_info "Starting Episode 01: ML APIs Setup..."
echo ""

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
if [ -z "$PROJECT_ID" ]; then
    error "Project ID not found. Please run: gcloud auth login"
    exit 1
fi
success "Active Project: ${BOLD}${PROJECT_ID}${NC}"
echo ""

print_info "Enabling Vision API..."
gcloud services enable vision.googleapis.com || warning "Vision API already enabled."

print_info "Enabling Natural Language API..."
gcloud services enable language.googleapis.com || warning "Language API already enabled."

print_info "Enabling Speech-to-Text API..."
gcloud services enable speech.googleapis.com || warning "Speech API already enabled."

echo ""
success "🎉 Episode 01 Setup Complete!"
