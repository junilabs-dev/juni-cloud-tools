#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP528 - Connecting Cloud Networks with NCC: Challenge Lab..."

export PROJECT_ID=$(gcloud config get-value project)
if [ -z "$PROJECT_ID" ]; then
    error "PROJECT_ID is not set in Cloud Shell."
    read -p "Please enter your Qwiklabs PROJECT_ID: " PROJECT_ID
    gcloud config set project $PROJECT_ID
fi

print_info "🚀 Enabling Network Connectivity API..."
gcloud services enable networkconnectivity.googleapis.com

print_info "🚀 Creating Central NCC Hub..."
gcloud network-connectivity hubs create global-hub --quiet || true

print_info "🔍 Discovering VPCs and VPN Tunnels..."
# Find VPN Tunnels (typically there are 4 tunnels, 2 for each office)
TUNNELS=$(gcloud compute vpn-tunnels list --format="value(name,selfLink,region)")
echo "Found VPN Tunnels:"
echo "$TUNNELS"

# Find VPC Networks
VPCS=$(gcloud compute networks list --format="value(name,selfLink)")
echo "Found VPCs:"
echo "$VPCS"

# Group VPN tunnels by region or name
TUNNELS_1=$(echo "$TUNNELS" | grep -i "office-1" | awk '{print $2}' | paste -sd "," -)
REGION_1=$(echo "$TUNNELS" | grep -i "office-1" | head -n 1 | awk '{print $3}' | awk -F/ '{print $NF}')

TUNNELS_2=$(echo "$TUNNELS" | grep -i "office-2" | awk '{print $2}' | paste -sd "," -)
REGION_2=$(echo "$TUNNELS" | grep -i "office-2" | head -n 1 | awk '{print $3}' | awk -F/ '{print $NF}')

if [ ! -z "$TUNNELS_1" ]; then
    print_info "Creating Spoke for Office 1 VPN Tunnels..."
    gcloud network-connectivity spokes linked-vpn-tunnels create office-1-vpn-spoke \
        --hub=global-hub \
        --region=$REGION_1 \
        --vpn-tunnels=$TUNNELS_1 \
        --site-to-site-data-transfer \
        --quiet || true
fi

if [ ! -z "$TUNNELS_2" ]; then
    print_info "Creating Spoke for Office 2 VPN Tunnels..."
    gcloud network-connectivity spokes linked-vpn-tunnels create office-2-vpn-spoke \
        --hub=global-hub \
        --region=$REGION_2 \
        --vpn-tunnels=$TUNNELS_2 \
        --site-to-site-data-transfer \
        --quiet || true
fi

print_info "🚀 Task 2 & 3: Connect VPC to VPC & VPC to On-prem"
VPC_WORKLOAD_1=$(echo "$VPCS" | grep -i "workload-1" | awk '{print $2}')
VPC_WORKLOAD_2=$(echo "$VPCS" | grep -i "workload-2" | awk '{print $2}')
VPC_ONPREM_1=$(echo "$VPCS" | grep -i "office-1" | awk '{print $2}')

# For Task 2 and 3 naming constraints
# Task 2: workload-1, workload-2
# Task 3: hybrid

if [ ! -z "$VPC_WORKLOAD_1" ]; then
    print_info "Creating Spoke for Workload VPC 1..."
    gcloud network-connectivity spokes linked-vpc-network create hybrid-workload-1-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_WORKLOAD_1 \
        --global --quiet || true
fi

if [ ! -z "$VPC_WORKLOAD_2" ]; then
    print_info "Creating Spoke for Workload VPC 2..."
    gcloud network-connectivity spokes linked-vpc-network create workload-2-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_WORKLOAD_2 \
        --global --quiet || true
fi

if [ ! -z "$VPC_ONPREM_1" ]; then
    print_info "Creating Spoke for On-Prem Office 1 VPC..."
    gcloud network-connectivity spokes linked-vpc-network create hybrid-office-1-vpc-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_ONPREM_1 \
        --global --quiet || true
fi

success "🎉 Lab GSP528 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
