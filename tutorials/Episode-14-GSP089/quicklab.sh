YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}Starting GSP089 - Cloud Monitoring: Qwik Start...${NC}"

export PROJECT_ID=$(gcloud config get-value project)

# Try to get zone from project metadata (Qwiklabs often sets this)
ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])" 2>/dev/null)

if [ -z "$ZONE" ]; then
    echo -e "${YELLOW}Could not automatically detect the zone.${NC}"
    read -p "Please enter the ZONE from your Qwiklabs panel (e.g. us-east1-b): " ZONE
fi

echo -e "${YELLOW}Using ZONE: $ZONE${NC}"

echo -e "${YELLOW}🚀 Creating VM instance 'lamp-1-vm' with Apache and Ops Agents...${NC}"
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

echo -e "${YELLOW}🔥 Adding Firewall Rule for HTTP...${NC}"
gcloud compute firewall-rules create default-allow-http \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server || true

echo -e "${GREEN}🎉 VM Setup Complete!${NC}"
echo -e "${CYAN}========================================================================${NC}"
echo -e "${YELLOW}Please wait 2-3 minutes for the startup script to finish installing agents.${NC}"
echo -e "${YELLOW}Then, go to the UI to complete the Uptime Check, Alerting Policy, and Dashboard!${NC}"
