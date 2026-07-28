#!/bin/bash
set -euo pipefail

source ./utils.sh
print_banner

print_info "Checking for Google Cloud SDK..."

if command -v gcloud &> /dev/null; then
    success "Google Cloud SDK is already installed."
    gcloud --version
    exit 0
fi

warning "Google Cloud SDK not found. Installing..."

# This is a generic installer for Linux/Debian-based systems
if [ -f /etc/debian_version ]; then
    print_info "Detected Debian/Ubuntu. Installing via apt..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update && sudo apt-get install -y google-cloud-cli
    success "Google Cloud SDK installed successfully."
else
    error "Unsupported OS for automatic installation. Please install manually: https://cloud.google.com/sdk/docs/install"
fi
