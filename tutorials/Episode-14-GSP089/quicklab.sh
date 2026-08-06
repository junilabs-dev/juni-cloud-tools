#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP089 - Cloud Monitoring: Qwik Start..."

export PROJECT_ID=$(gcloud config get-value project)

# Try to get zone from project metadata (Qwiklabs often sets this)
ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])" 2>/dev/null)

if [ -z "$ZONE" ]; then
    error "Could not automatically detect the zone."
    read -p "Please enter the ZONE from your Qwiklabs panel (e.g. us-east1-b): " ZONE
fi

print_info "Using ZONE: $ZONE"

print_info "🚀 Creating VM instance 'lamp-1-vm' with Apache and Ops Agents..."
gcloud compute instances create lamp-1-vm \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --tags=http-server \
    --metadata=startup-script='#!/bin/bash
apt-get update
apt-get install -y apache2 php
service apache2 restart
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install
'

print_info "🔥 Adding Firewall Rule for HTTP..."
gcloud compute firewall-rules create default-allow-http \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server || true

success "🎉 VM Setup Complete!"
print_info "========================================================================"
print_info "Please wait 2-3 minutes for the startup script to finish installing agents."
print_info "Then, go to the UI to complete the Uptime Check, Alerting Policy, and Dashboard!"
