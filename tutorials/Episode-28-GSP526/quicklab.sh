#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP526 - Privileged Access with IAM: Challenge Lab..."

PROJECT_ID=$(gcloud config get-value project)
USER_1=$(gcloud config get-value account)
USER_2=$(gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format="value(bindings.members)" | grep -i "user:.*@qwiklabs.net" | sed 's/user://' | grep -v "^${USER_1}$" | head -n 1)

if [ -z "$USER_2" ]; then
    read -p "Could not find User 2 automatically. Please enter Username 2: " USER_2
fi

print_info "✅ Primary User (Admin): $USER_1"
print_info "✅ Secondary User (Security Lead): $USER_2"

# Task 1: Enable PAM API & Service Agent Role
print_info "🚀 Task 1: Enabling Privileged Access Manager..."
gcloud services enable privilegedaccessmanager.googleapis.com

print_info "🚀 Provisioning PAM Service Agent..."
gcloud beta services identity create --service=privilegedaccessmanager.googleapis.com --project=$PROJECT_ID || true

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
print_info "🚀 Granting PAM Service Agent role on Project level..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-pam.iam.gserviceaccount.com" \
    --role="roles/privilegedaccessmanager.serviceAgent" \
    --quiet || true

ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format="json" | grep -A1 '"type": "organization"' | grep '"id"' | grep -o '[0-9]\+')
if [ ! -z "$ORG_ID" ]; then
    print_info "🚀 Granting PAM Service Agent role on Org level..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:service-org-${ORG_ID}@gcp-sa-pam.iam.gserviceaccount.com" \
        --role="roles/privilegedaccessmanager.serviceAgent" \
        --quiet || true
fi

print_info "⏳ Waiting 20 seconds for PAM service agent propagation..."
sleep 20

# Task 2: Create the entitlement
print_info "🚀 Task 2: Creating the entitlement..."
cat <<EOF > entitlement.yaml
eligibleUsers:
- principals:
  - user:$USER_1
approvalWorkflow:
  manualApprovals:
    requireApproverJustification: false
    steps:
    - approvalsNeeded: 1
      approvers:
      - principals:
        - user:$USER_2
privilegedAccess:
  gcpIamAccess:
    resourceType: cloudresourcemanager.googleapis.com/Project
    resource: //cloudresourcemanager.googleapis.com/projects/$PROJECT_ID
    roleBindings:
    - role: roles/compute.admin
maxRequestDuration: 36000s
requesterJustificationConfig:
  notMandatory: {}
EOF

gcloud pam entitlements create pam-entitlement \
    --project=$PROJECT_ID \
    --location=global \
    --entitlement-file=entitlement.yaml \
    --quiet || true

# Task 3: Update the entitlement
print_info "🚀 Task 3: Updating the entitlement..."
sed -i 's/36000s/14400s/' entitlement.yaml
gcloud pam entitlements update pam-entitlement \
    --project=$PROJECT_ID \
    --location=global \
    --entitlement-file=entitlement.yaml \
    --quiet || true

# Task 4: Request temporary elevated access
print_info "🚀 Task 4: Requesting temporary elevated access..."
gcloud pam grants create \
    --entitlement=pam-entitlement \
    --project=$PROJECT_ID \
    --location=global \
    --requested-duration=14400s \
    --justification="Testing PAM" \
    --quiet || true

print_info "======================================================"
print_info "🚨 MANUAL STEPS REQUIRED FOR TASKS 4 & 5 🚨"
print_info "1. Open an Incognito Window and log in with USER 2: $USER_2"
print_info "2. Go to IAM & Admin > Privileged Access Manager"
print_info "3. Go to the 'Approvals' tab, click the pending request, and APPROVE it."
print_info "4. Wait 10-20 seconds for it to become Active."
print_info "5. Go to 'Active Grants', and REVOKE it."
print_info "6. Check your Qwiklabs progress for Task 4 and 5 (Ensure they are 100/100)."
print_info "======================================================"

read -p "Press Enter AFTER you have successfully Approved AND Revoked the grant as User 2... " 

# Task 6: Delete the entitlement
print_info "🚀 Task 6: Deleting the entitlement..."
gcloud pam entitlements delete pam-entitlement \
    --project=$PROJECT_ID \
    --location=global \
    --quiet || true

success "🎉 Lab GSP526 Complete!"
print_info "Go back to Qwiklabs and check the final progress button!"
