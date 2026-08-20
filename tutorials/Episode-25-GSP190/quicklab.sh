#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP190 - IAM Custom Roles..."

export PROJECT_ID=$(gcloud config get-value project)
if [ -z "$PROJECT_ID" ]; then
    error "PROJECT_ID is not set in Cloud Shell."
    read -p "Please enter your Qwiklabs PROJECT_ID: " PROJECT_ID
    gcloud config set project $PROJECT_ID
fi

print_info "🚀 Task 4: Create a custom role using a YAML file..."
cat > role-definition.yaml << EOF
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
EOF

gcloud iam roles create editor --project $PROJECT_ID --file role-definition.yaml --quiet || true

print_info "🚀 Task 4: Create a custom role using flags..."
gcloud iam roles create viewer --project $PROJECT_ID \
  --title "Role Viewer" --description "Custom role description." \
  --permissions compute.instances.get,compute.instances.list --stage ALPHA --quiet || true


print_info "🚀 Task 6: Update a custom role using a YAML file..."
ETAG=$(gcloud iam roles describe editor --project $PROJECT_ID --format="value(etag)")

cat > new-role-definition.yaml << EOF
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
etag: $ETAG
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
- storage.buckets.get
- storage.buckets.list
EOF

gcloud iam roles update editor --project $PROJECT_ID --file new-role-definition.yaml --quiet || true


print_info "🚀 Task 6: Update a custom role using flags..."
gcloud iam roles update viewer --project $PROJECT_ID \
  --add-permissions storage.buckets.get,storage.buckets.list --quiet || true


print_info "🚀 Task 7: Disable a custom role..."
gcloud iam roles update viewer --project $PROJECT_ID \
  --stage DISABLED --quiet || true


print_info "🚀 Task 8: Delete a custom role..."
gcloud iam roles delete viewer --project $PROJECT_ID --quiet || true


print_info "🚀 Task 9: Restore a custom role..."
gcloud iam roles undelete viewer --project $PROJECT_ID --quiet || true

success "🎉 Lab GSP190 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
