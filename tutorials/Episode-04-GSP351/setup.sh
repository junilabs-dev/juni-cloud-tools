#!/bin/bash

# Source utils for banner and colors
source ../../bash/utils.sh

print_banner
print_info "Starting GSP351: Migrate MySQL Data to Cloud SQL (Hybrid Automation)..."
echo ""

# Get Region and Zone
export ZONE=$(gcloud config get compute/zone)
export REGION=$(gcloud config get compute/region)

if [ -z "$ZONE" ] || [ -z "$REGION" ]; then
    echo -e "${RED}Error: ZONE or REGION not set in gcloud config. Please set them first.${NC}"
    exit 1
fi

echo -e "${YELLOW}🔍 Fetching Source VM details...${NC}"
SOURCE_VM=$(gcloud compute instances list --filter="name~'mysql'" --format="value(name)" | head -n 1)

if [ -z "$SOURCE_VM" ]; then
    echo -e "${RED}Error: Could not find the MySQL source compute instance.${NC}"
    exit 1
fi

SOURCE_IP=$(gcloud compute instances describe $SOURCE_VM --zone=$ZONE --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

echo -e "\n=========================================================="
echo -e "${BOLD}${CYAN}🎯 YOUR UNIQUE SOURCE IP: ${WHITE}${SOURCE_IP}${NC}"
echo -e "=========================================================="

echo -e "\n${BOLD}${YELLOW}⚠️  MANUAL STEPS REQUIRED FOR TASKS 1, 2, 3${NC}"
echo "1. Go to Database Migration > Connection profiles and CREATE a MySQL profile."
echo "   Use the IP address above, Username: admin, Password: changeme."
echo "2. Go to Migration jobs and CREATE a One-Time migration job (IP allowlist)."
echo "   Destination: Choose the first Existing instance from Qwiklabs."
echo "3. CREATE a second Continuous migration job (VPC Peering)."
echo "   Destination: Choose the second Existing instance from Qwiklabs."
echo -e "\n${BOLD}Start BOTH jobs and wait for them to complete/run.${NC}"
echo "=========================================================="

echo ""
read -p "🛑 PRESS ENTER ONLY AFTER YOUR CONTINUOUS MIGRATION JOB STATUS IS 'RUNNING' " DUMMY

echo -e "\n${GREEN}🚀 Executing Task 4: Testing Replication (Updating DB)...${NC}"
echo -e "${YELLOW}Please wait, SSHing into the source VM... (Type 'Y' and press Enter if prompted for SSH keys)${NC}"

gcloud compute ssh $SOURCE_VM --zone=$ZONE --quiet --command="mysql -u admin -pchangeme -e \"use customers_data; update customers set gender = 'FEMALE' where addressKey = 934;\""

echo -e "\n=========================================================="
echo -e "${BOLD}${GREEN}✅ Task 4 Backend Update Complete!${NC}"
echo "Wait exactly 60 seconds, then click 'Check my progress' for Task 4."
echo -e "\n${BOLD}${YELLOW}👉 Final Step (Task 5):${NC} Go back to the DMS UI, click your Continuous Migration Job, and click 'PROMOTE'."
echo "=========================================================="
