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

# ── Step 1: Service Account ──────────────────────────────────────────────────
SA_NAME="ml-api-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

print_info "Creating Service Account..."
gcloud iam service-accounts create "$SA_NAME" \
    --display-name="ML API Service Account" 2>/dev/null || true

print_info "Assigning BigQuery & Storage roles..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/bigquery.dataEditor" --quiet
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/storage.objectAdmin" --quiet

print_info "Creating fresh credential key..."
rm -f key.json
gcloud iam service-accounts keys create key.json \
    --iam-account="${SA_EMAIL}"
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/key.json"
success "key.json created. Waiting 15s for IAM to propagate..."
sleep 15

# ── Step 2: Write the complete Python solution directly ──────────────────────
print_info "Writing complete Python solution..."
cat > analyze-images.py << 'PYTHON_SCRIPT'
import os
import sys
import json
from google.cloud import vision, bigquery, storage, translate_v2 as translate

def run(project_id, bucket_name):
    vision_client  = vision.ImageAnnotatorClient()
    bq_client      = bigquery.Client(project=project_id)
    storage_client = storage.Client(project=project_id)
    translate_client = translate.Client()

    table_ref = bq_client.dataset("image_classification_dataset").table("image_text_detail")
    table     = bq_client.get_table(table_ref)

    bucket  = storage_client.bucket(bucket_name)
    blobs   = bucket.list_blobs()
    rows_for_bq = []

    for blob in blobs:
        if not blob.name.endswith(".jpg"):
            continue

        print(f"Processing: {blob.name}")
        file_content = blob.download_as_bytes()

        # ── Vision API ──────────────────────────────────────────────────────
        image_object = vision.Image(content=file_content)
        response     = vision_client.document_text_detection(image=image_object)
        annotation   = response.full_text_annotation

        if not annotation.text:
            print(f"  No text found in {blob.name}, skipping.")
            continue

        # Save extracted text back to Cloud Storage
        text_blob_name = blob.name.replace(".jpg", ".txt")
        text_blob      = bucket.blob(text_blob_name)
        text_blob.upload_from_string(annotation.text)
        print(f"  Text saved to gs://{bucket_name}/{text_blob_name}")

        # ── Translation API ─────────────────────────────────────────────────
        for page in annotation.pages:
            for block in page.blocks:
                block_text = ""
                for paragraph in block.paragraphs:
                    for word in paragraph.words:
                        word_text = "".join([s.text for s in word.symbols])
                        block_text += word_text + " "
                block_text = block_text.strip()
                if not block_text:
                    continue

                # Detect locale from first annotation
                locale = "und"
                if annotation.pages:
                    # Use the detected language from block if available
                    if block.property and block.property.detected_languages:
                        locale = block.property.detected_languages[0].language_code

                if locale != "ja":
                    translation = translate_client.translate(block_text, target_language="ja")
                    translated_text = translation["translatedText"]
                else:
                    translated_text = block_text

                rows_for_bq.append({
                    "file_name":       blob.name,
                    "locale":          locale,
                    "description":     block_text,
                    "translated_text": translated_text,
                })
                print(f"  [{locale}] {block_text[:60]}...")

    if rows_for_bq:
        print(f"\nUploading {len(rows_for_bq)} rows to BigQuery...")
        errors = bq_client.insert_rows(table, rows_for_bq)
        if errors:
            print(f"BigQuery errors: {errors}")
        else:
            print("Data successfully uploaded to BigQuery!")
    else:
        print("No data to upload.")

if __name__ == "__main__":
    project_id  = sys.argv[1]
    bucket_name = sys.argv[2]
    run(project_id, bucket_name)
PYTHON_SCRIPT

# ── Step 3: Run it ───────────────────────────────────────────────────────────
print_info "Running Python script (may take 2-3 minutes)..."
python3 analyze-images.py "$PROJECT_ID" "$PROJECT_ID"

echo ""
success "🎉 All done! Go check your Qwiklabs score — it should be 100/100!"
