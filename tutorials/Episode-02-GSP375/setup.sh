#!/bin/bash

# Source utils for banner and colors
source ../../bash/utils.sh

print_banner
print_info "Starting GSP375: Share Data using Google Data Cloud Challenge Lab..."
echo ""

# --- PROMPT USER FOR DYNAMIC LAB VALUES ---
echo -e "${YELLOW}⚠️  Qwiklabs randomizes this lab for every student!${NC}"
echo "Please enter the exact values from your lab instructions panel:"
echo ""

read -p "👉 1. Partner Project ID: " PARTNER_PROJECT
read -p "👉 2. Partner Authorized View Name: " PARTNER_VIEW
read -p "👉 3. Customer Username (Email): " CUSTOMER_USER
read -p "👉 4. Customer Project ID: " CUSTOMER_PROJECT
read -p "👉 5. Customer Authorized View Name: " CUSTOMER_VIEW
read -p "👉 6. Partner Username (Email): " PARTNER_USER
echo ""

if [[ -z "$PARTNER_PROJECT" || -z "$PARTNER_VIEW" || -z "$CUSTOMER_USER" || -z "$CUSTOMER_PROJECT" || -z "$CUSTOMER_VIEW" || -z "$PARTNER_USER" ]]; then
    error "All fields are required. Please run the script again."
    exit 1
fi

echo -e "\n🚀 Starting automation... (Make sure you are running this from the main Cloud Shell)"

# ═══════════════════════════════════════════════════════════════════════════════
# TASK 1: Create Partner Authorized View
# ═══════════════════════════════════════════════════════════════════════════════
print_info "[Task 1] Creating Partner Authorized View..."
bq --project_id="${PARTNER_PROJECT}" mk --use_legacy_sql=false \
    --view="SELECT * FROM \`bigquery-public-data.geo_us_boundaries.zip_codes\`" \
    "${PARTNER_PROJECT}:demo_dataset.${PARTNER_VIEW}" 2>/dev/null || true

print_info "[Task 1] Authorizing the view in the dataset..."
bq show --format=prettyjson "${PARTNER_PROJECT}:demo_dataset" > partner_ds.json
jq --arg projectId "${PARTNER_PROJECT}" \
   --arg datasetId "demo_dataset" \
   --arg tableId "${PARTNER_VIEW}" \
   '.access = (.access // []) + [{"view": {"projectId": $projectId, "datasetId": $datasetId, "tableId": $tableId}}] | .access |= unique' \
   partner_ds.json > partner_ds_updated.json
bq update --source partner_ds_updated.json "${PARTNER_PROJECT}:demo_dataset"

print_info "[Task 1] Granting Data Viewer role to Customer User..."
bq get-iam-policy "table:${PARTNER_PROJECT}:demo_dataset.${PARTNER_VIEW}" > partner_policy.json
jq --arg member "user:${CUSTOMER_USER}" \
   --arg role "roles/bigquery.dataViewer" \
   '.bindings = (.bindings // []) + [{"role": $role, "members": [$member]}]' \
   partner_policy.json > partner_policy_updated.json
bq set-iam-policy partner_policy_updated.json "table:${PARTNER_PROJECT}:demo_dataset.${PARTNER_VIEW}"

success "Task 1 Complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# TASK 2: Update the customer data table
# ═══════════════════════════════════════════════════════════════════════════════
print_info "[Task 2] Updating customer data table..."
bq --project_id="${CUSTOMER_PROJECT}" query --use_legacy_sql=false \
"UPDATE \`${CUSTOMER_PROJECT}.customer_dataset.customer_info\` cust
SET cust.county=vw.county
FROM \`${PARTNER_PROJECT}.demo_dataset.${PARTNER_VIEW}\` vw
WHERE vw.zip_code=cust.postal_code;"

success "Task 2 Complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# TASK 3: Create Customer Authorized View
# ═══════════════════════════════════════════════════════════════════════════════
print_info "[Task 3] Creating Customer Authorized View..."
bq --project_id="${CUSTOMER_PROJECT}" mk --use_legacy_sql=false \
    --view="SELECT county, COUNT(1) AS Count FROM \`${CUSTOMER_PROJECT}.customer_dataset.customer_info\` cust GROUP BY county HAVING county is not null" \
    "${CUSTOMER_PROJECT}:customer_dataset.${CUSTOMER_VIEW}" 2>/dev/null || true

print_info "[Task 3] Authorizing the view in the dataset..."
bq show --format=prettyjson "${CUSTOMER_PROJECT}:customer_dataset" > customer_ds.json
jq --arg projectId "${CUSTOMER_PROJECT}" \
   --arg datasetId "customer_dataset" \
   --arg tableId "${CUSTOMER_VIEW}" \
   '.access = (.access // []) + [{"view": {"projectId": $projectId, "datasetId": $datasetId, "tableId": $tableId}}] | .access |= unique' \
   customer_ds.json > customer_ds_updated.json
bq update --source customer_ds_updated.json "${CUSTOMER_PROJECT}:customer_dataset"

print_info "[Task 3] Granting Data Viewer role to Partner User..."
bq get-iam-policy "table:${CUSTOMER_PROJECT}:customer_dataset.${CUSTOMER_VIEW}" > customer_policy.json
jq --arg member "user:${PARTNER_USER}" \
   --arg role "roles/bigquery.dataViewer" \
   '.bindings = (.bindings // []) + [{"role": $role, "members": [$member]}]' \
   customer_policy.json > customer_policy_updated.json
bq set-iam-policy customer_policy_updated.json "table:${CUSTOMER_PROJECT}:customer_dataset.${CUSTOMER_VIEW}"

success "Task 3 Complete!"

echo -e "\n=========================================================="
echo -e "${BOLD}${GREEN}🎉 Tasks 1, 2, and 3 are COMPLETE! Check your Qwiklabs score.${NC}"
echo -e "${YELLOW}⚠️  Note: Task 4 (Data Studio Visualization) must be done manually in the UI.${NC}"
echo "=========================================================="
