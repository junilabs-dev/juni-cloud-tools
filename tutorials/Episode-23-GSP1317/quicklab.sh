#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP1317 - Establish VPC to VPC Connectivity using NCC..."

export PROJECT_ID=$(gcloud config get-value project)
export REGION=us-east4
export ZONE=us-east4-b

print_info "🚀 Enabling Network Connectivity API..."
gcloud services enable networkconnectivity.googleapis.com
gcloud services enable dns.googleapis.com

print_info "🚀 Task 1: Creating NCC hub..."
gcloud network-connectivity hubs create ncc-hub --quiet

print_info "🚀 Task 2: Configuring VPCs as NCC spokes..."
gcloud network-connectivity spokes linked-vpc-network create vpc1-spoke1 \
  --hub=ncc-hub \
  --vpc-network=vpc1-ncc \
  --exclude-export-ranges=10.1.2.0/24 \
  --global --quiet

gcloud network-connectivity spokes linked-vpc-network create vpc2-spoke2 \
  --hub=ncc-hub \
  --vpc-network=vpc2-ncc \
  --exclude-export-ranges=10.3.3.0/24 \
  --global --quiet

print_info "🚀 Task 4: Setting up Private Service Connect..."
print_info "Reserving internal IP address..."
gcloud compute addresses create cloudsql-psc \
  --region=$REGION \
  --subnet=vpc2-ncc-subnet1 --quiet

print_info "Getting Cloud SQL instance details..."
INSTANCE_NAME=$(gcloud sql instances list --format="value(name)" | head -n 1)
if [ -z "$INSTANCE_NAME" ]; then
    print_info "Could not find any Cloud SQL instance. Waiting 30s..."
    sleep 30
    INSTANCE_NAME=$(gcloud sql instances list --format="value(name)" | head -n 1)
fi

SVC_ATTACHMENT=$(gcloud sql instances describe $INSTANCE_NAME --format="value(pscServiceAttachmentLink)")
DNS_RECORD=$(gcloud sql instances describe $INSTANCE_NAME --format="value(dnsName)")

print_info "Creating Private Service Connect endpoint..."
gcloud compute forwarding-rules create cloudsql-psc-ep \
  --address=cloudsql-psc \
  --region=$REGION \
  --network=vpc2-ncc \
  --target-service-attachment=$SVC_ATTACHMENT \
  --allow-psc-global-access --quiet

print_info "Configuring DNS managed zone and record..."
gcloud dns managed-zones create cloudsql-dns \
  --description="DNS zone for the Cloud SQL instances" \
  --dns-name=us-east4.sql.goog. \
  --networks=vpc2-ncc \
  --visibility=private --quiet

ADDRESS=$(gcloud compute addresses describe cloudsql-psc --region=$REGION --format="value(address)")

gcloud dns record-sets create $DNS_RECORD \
  --type=A \
  --rrdatas=$ADDRESS \
  --zone=cloudsql-dns --quiet

print_info "🚀 Task 5: Connecting to Cloud SQL via Private Service Connect..."
cat > sql_script.sql << EOF
CREATE DATABASE company;
\c company
CREATE TABLE employees ( id SERIAL PRIMARY KEY, first VARCHAR(255) NOT NULL, last VARCHAR(255) NOT NULL, salary DECIMAL (10, 2) );
INSERT INTO employees (first, last, salary) VALUES ('Max', 'Mustermann', 5000.00), ('Anna', 'Schmidt', 7000.00), ('Peter', 'Mayer', 6000.00);
EOF

print_info "Waiting for VM to be ready for SSH..."
MAX_TRIES=5
TRIES=0
while [ $TRIES -lt $MAX_TRIES ]; do
  gcloud compute scp sql_script.sql cloudsql-client:~ --zone=$ZONE --tunnel-through-iap --quiet && break
  print_info "SSH failed, retrying in 10s..."
  sleep 10
  TRIES=$((TRIES+1))
done

gcloud compute ssh cloudsql-client --zone=$ZONE --tunnel-through-iap --quiet --command="PGPASSWORD=changeme psql \"sslmode=disable dbname=postgres user=postgres host=$DNS_RECORD\" -f sql_script.sql"

print_info "====================================================="
print_info "🛑 STOP HERE! Go to Qwiklabs and click 'Check my progress'"
print_info "for all the tasks. Ensure you get 100/100 points."
print_info "====================================================="
read -p "Press [Enter] after you have verified the points to finish the cleanup..."

print_info "🗑️ Cleanup: Deleting resources..."
gcloud network-connectivity spokes delete vpc1-spoke1 --global --quiet
gcloud network-connectivity spokes delete vpc2-spoke2 --global --quiet
gcloud network-connectivity hubs delete ncc-hub --quiet
gcloud dns record-sets delete $DNS_RECORD --type=A --zone=cloudsql-dns --quiet
gcloud dns managed-zones delete cloudsql-dns --quiet

success "🎉 Lab GSP1317 Setup Complete!"
