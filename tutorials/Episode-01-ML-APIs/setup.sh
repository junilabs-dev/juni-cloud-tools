#!/bin/bash
set -euo pipefail

source ../../bash/utils.sh

print_banner
print_info "Starting GSP329: ML APIs Challenge Lab Automation..."
echo ""

PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
if [ -z "$PROJECT_ID" ]; then
    error "Project ID not found."
    exit 1
fi
success "Active Project: ${BOLD}${PROJECT_ID}${NC}"
echo ""

# 1. Create Service Account and Assign Roles
SA_NAME="ml-api-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

print_info "Creating Service Account: $SA_NAME"
gcloud iam service-accounts create $SA_NAME --display-name="ML API Service Account" 2>/dev/null || true

print_info "Assigning Roles (Storage & BigQuery)..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/bigquery.dataEditor" >/dev/null

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/storage.objectAdmin" >/dev/null

print_info "Creating and downloading Service Account Key..."
gcloud iam service-accounts keys create key.json \
    --iam-account=$SA_EMAIL 2>/dev/null || true
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/key.json

# 2. Download and Modify Python Script
print_info "Downloading Python script from Cloud Storage..."
gsutil cp gs://$PROJECT_ID/analyze-images-v2.py .

print_info "Injecting Solution Code into Python script..."
# Using robust regex to preserve python indentation and replace the entire comment line
sed -i 's/^\( *\)# TBD: Create a Vision API image object.*/\1image_object = vision.Image(content=file_content)/g' analyze-images-v2.py
sed -i 's/^\( *\)# TBD: Detect text in the image.*/\1response = vision_client.document_text_detection(image=image_object)/g' analyze-images-v2.py
sed -i "s/^\( *\)# TBD: According to the target language.*/\1translation = translate_client.translate(desc, target_language='ja')/g" analyze-images-v2.py
sed -i 's/^\( *\)# errors = bq_client.insert_rows(table, rows_for_bq).*/\1errors = bq_client.insert_rows(table, rows_for_bq)/g' analyze-images-v2.py

# 3. Run the script
print_info "Running the Python script (This may take a minute)..."
python3 analyze-images-v2.py $PROJECT_ID $PROJECT_ID

echo ""
success "🎉 Lab Automation Complete! Check your Qwiklabs score now!"
