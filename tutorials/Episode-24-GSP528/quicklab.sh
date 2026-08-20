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
gcloud network-connectivity hubs create global-hub --quiet

print_info "🚀 Task 1: Connect 2 On-prem VPCs with NCC"
TUNNELS_OFFICE_1=$(gcloud compute vpn-tunnels list --filter="name:office-1" --format="value(selfLink)" | paste -sd "," -)
REGION1=$(gcloud compute vpn-tunnels list --filter="name:office-1" --format="value(region)" | head -n 1 | awk -F/ '{print $NF}')
if [ ! -z "$TUNNELS_OFFICE_1" ]; then
    print_info "Creating Spoke for Office 1 VPN Tunnels..."
    gcloud network-connectivity spokes linked-vpn-tunnels create office-1-vpn-spoke \
        --hub=global-hub \
        --region=$REGION1 \
        --vpn-tunnels=$TUNNELS_OFFICE_1 \
        --site-to-site-data-transfer \
        --quiet
fi

TUNNELS_OFFICE_2=$(gcloud compute vpn-tunnels list --filter="name:office-2" --format="value(selfLink)" | paste -sd "," -)
REGION2=$(gcloud compute vpn-tunnels list --filter="name:office-2" --format="value(region)" | head -n 1 | awk -F/ '{print $NF}')
if [ ! -z "$TUNNELS_OFFICE_2" ]; then
    print_info "Creating Spoke for Office 2 VPN Tunnels..."
    gcloud network-connectivity spokes linked-vpn-tunnels create office-2-vpn-spoke \
        --hub=global-hub \
        --region=$REGION2 \
        --vpn-tunnels=$TUNNELS_OFFICE_2 \
        --site-to-site-data-transfer \
        --quiet
fi

print_info "🚀 Task 2 & 3: Connect VPC to VPC & VPC to On-prem"
VPC_WORKLOAD_1=$(gcloud compute networks list --filter="name:workload-1" --format="value(selfLink)" | head -n 1)
VPC_WORKLOAD_2=$(gcloud compute networks list --filter="name:workload-2" --format="value(selfLink)" | head -n 1)
VPC_ONPREM_1=$(gcloud compute networks list --filter="name:office-1" --format="value(selfLink)" | head -n 1)

if [ ! -z "$VPC_WORKLOAD_1" ]; then
    print_info "Creating Spoke for Workload VPC 1..."
    gcloud network-connectivity spokes linked-vpc-network create hybrid-workload-1-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_WORKLOAD_1 \
        --global --quiet
fi

if [ ! -z "$VPC_WORKLOAD_2" ]; then
    print_info "Creating Spoke for Workload VPC 2..."
    gcloud network-connectivity spokes linked-vpc-network create workload-2-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_WORKLOAD_2 \
        --global --quiet
fi

if [ ! -z "$VPC_ONPREM_1" ]; then
    print_info "Creating Spoke for On-Prem Office 1 VPC..."
    gcloud network-connectivity spokes linked-vpc-network create hybrid-office-1-vpc-spoke \
        --hub=global-hub \
        --vpc-network=$VPC_ONPREM_1 \
        --global --quiet
fi

success "🎉 Lab GSP528 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
