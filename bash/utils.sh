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
WHITE='\e[97m'
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
    clear
    echo -e "${CYAN}${BOLD}"
    echo "        0 1 0 1 1"
    echo "        1 0 1 0 1"
    echo "          0 1 0 1"
    echo "            0 0 1"
    echo "            1 0 0"
    echo "            0 1 1"
    echo "      1 0 1 1 1 0"
    echo "      0 1 0   1 0"
    echo "        0 1 1 0 0"
    echo "          1 0 0 1 0"
    echo -e "${NC}"
    echo -e "       ${BOLD}${WHITE}@junilabsdev${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${YELLOW}${BOLD}  🚀 Google Cloud Automation Toolkit 🚀${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo ""
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
