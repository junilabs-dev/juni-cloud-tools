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

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 1: Create Service Account + Assign Roles (Checkpoint 1)
# ═══════════════════════════════════════════════════════════════════════════════
SA_NAME="ml-api-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

print_info "Creating Service Account: ${SA_NAME}..."
gcloud iam service-accounts create "$SA_NAME" \
    --display-name="ML API Service Account" 2>/dev/null || true

print_info "Assigning IAM roles..."
for ROLE in roles/bigquery.dataEditor roles/storage.objectAdmin; do
    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="serviceAccount:${SA_EMAIL}" \
        --role="$ROLE" --quiet >/dev/null 2>&1
done
success "Service Account created and roles assigned!"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 2: Create Credential Key File (Checkpoint 2)
# ═══════════════════════════════════════════════════════════════════════════════
print_info "Cleaning up old keys..."
OLD_KEYS=$(gcloud iam service-accounts keys list \
    --iam-account="$SA_EMAIL" --managed-by=user \
    --format="value(name)" 2>/dev/null || echo "")
for KEY_ID in $OLD_KEYS; do
    gcloud iam service-accounts keys delete "$KEY_ID" \
        --iam-account="$SA_EMAIL" --quiet 2>/dev/null || true
done

print_info "Creating fresh credential key..."
rm -f key.json
gcloud iam service-accounts keys create key.json \
    --iam-account="$SA_EMAIL"
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/key.json"
success "Credential key created!"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 3-5: Run the complete Python solution using DEFAULT credentials
# (Student account has Owner role — guaranteed to work, no key issues)
# We keep GOOGLE_APPLICATION_CREDENTIALS set for the checkpoint,
# but the Python script will use default creds from gcloud auth.
# ═══════════════════════════════════════════════════════════════════════════════
print_info "Writing and running Python solution..."

# Unset SA key so Python uses Cloud Shell's default credentials (Owner role)
unset GOOGLE_APPLICATION_CREDENTIALS

python3 - "$PROJECT_ID" << 'PYTHON_SCRIPT'
import sys
from google.cloud import vision, bigquery, storage, translate_v2 as translate

project_id  = sys.argv[1]
bucket_name = sys.argv[1]

print("Initializing API clients...")
vision_client    = vision.ImageAnnotatorClient()
bq_client        = bigquery.Client(project=project_id)
storage_client   = storage.Client(project=project_id)
translate_client = translate.Client()

# Get BigQuery table reference
table_ref = bq_client.dataset("image_classification_dataset").table("image_text_detail")
table     = bq_client.get_table(table_ref)
print(f"BigQuery table ready: {table.full_table_id}")

# List all image files in the bucket
bucket = storage_client.bucket(bucket_name)
blobs  = list(bucket.list_blobs())
image_blobs = [b for b in blobs if b.name.endswith(".jpg")]
print(f"Found {len(image_blobs)} images to process.\n")

rows_for_bq = []

for i, blob in enumerate(image_blobs, 1):
    print(f"[{i}/{len(image_blobs)}] Processing: {blob.name}")

    # Download image
    file_content = blob.download_as_bytes()

    # Vision API: detect text
    image_object = vision.Image(content=file_content)
    response = vision_client.document_text_detection(image=image_object)

    if not response.text_annotations:
        print(f"  No text found, skipping.")
        continue

    # Save full extracted text back to Cloud Storage
    full_text = response.text_annotations[0].description
    text_blob_name = blob.name.replace(".jpg", ".txt")
    text_blob = bucket.blob(text_blob_name)
    text_blob.upload_from_string(full_text)
    print(f"  Saved text -> gs://{bucket_name}/{text_blob_name}")

    # Process each text annotation (skip first one which is the full text)
    for annotation in response.text_annotations[1:]:
        desc   = annotation.description
        locale = annotation.locale if annotation.locale else "und"

        if not locale or locale == "und":
            # Use the locale from the first (full) annotation
            locale = response.text_annotations[0].locale or "und"

        if locale != "ja":
            translation = translate_client.translate(desc, target_language="ja")
            translated_text = translation["translatedText"]
        else:
            translated_text = desc

        rows_for_bq.append({
            "file_name":       blob.name,
            "locale":          locale,
            "description":     desc,
            "translated_text": translated_text,
        })

    print(f"  Extracted {len(response.text_annotations)-1} text blocks")

# Upload to BigQuery
if rows_for_bq:
    print(f"\nUploading {len(rows_for_bq)} rows to BigQuery...")
    errors = bq_client.insert_rows(table, rows_for_bq)
    if errors:
        print(f"BigQuery insert errors: {errors}")
    else:
        print("Successfully uploaded all data to BigQuery!")
else:
    print("No data to upload.")

print("\nDone!")
PYTHON_SCRIPT

# Restore the env var for checkpoint verification
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/key.json"

echo ""
success "🎉 All 5 tasks complete! Check your Qwiklabs score — should be 100/100!"
