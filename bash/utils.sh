#!/bin/bash

# ==============================================================================
# 🌟 GCP Automation Toolkit - Utils 🌟
# Contains reusable UI components and colors
# ==============================================================================

# --- Define Colors ---
BOLD='\e[1m'
BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
CYAN='\e[36m'
NC='\e[0m' # No Color

# --- Helper Functions ---
print_info() {
    echo -e "${BLUE}${BOLD}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}${BOLD}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}${BOLD}[ERROR]${NC} $1"
}

print_banner() {
    echo -e "${CYAN}"
    echo "================================================================="
    echo "      🌟 Google Cloud Automation Toolkit - By JuniLabs 🌟      "
    echo "================================================================="
    echo -e "${NC}"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        error "Command '$1' could not be found. Please install it."
        exit 1
    fi
}

check_login() {
    print_info "Verifying gcloud authentication..."
    if ! gcloud auth print-access-token &> /dev/null; then
        error "You are not authenticated with gcloud."
        echo "Run: gcloud auth login"
        exit 1
    fi
    success "Authenticated successfully."
}
