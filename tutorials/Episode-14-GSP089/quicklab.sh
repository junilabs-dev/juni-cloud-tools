#!/bin/bash
source ../../bash/utils.sh
print_banner
print_info "Starting GSP089 - Cloud Monitoring: Qwik Start..."

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get compute/region)
export ZONE=$(gcloud config get compute/zone)

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
