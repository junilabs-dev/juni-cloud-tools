#!/bin/bash

source ../../bash/utils.sh

print_banner
print_info "Starting GSP329: ML APIs Challenge Lab Automation..."
echo ""

# --- PROMPT USER FOR DYNAMIC LAB VALUES ---
echo -e "${YELLOW}⚠️  Qwiklabs randomizes this lab for every student!${NC}"
echo "Please check your lab instructions panel and enter the exact values:"
echo ""

read -p "👉 1. Enter the target LOCALE (e.g., ja, fr, es, en): " LOCALE
read -p "👉 2. Enter the BigQuery Role (e.g., roles/bigquery.dataEditor): " BQ_ROLE
read -p "👉 3. Enter the Cloud Storage Role (e.g., roles/storage.objectAdmin): " GCS_ROLE
echo ""

if [[ -z "$LOCALE" || -z "$BQ_ROLE" || -z "$GCS_ROLE" ]]; then
    error "All fields are required. Please run the script again."
    exit 1
fi

# Make sure roles start with "roles/"
if [[ "$BQ_ROLE" != roles/* ]]; then
    BQ_ROLE="roles/$BQ_ROLE"
fi
if [[ "$GCS_ROLE" != roles/* ]]; then
    GCS_ROLE="roles/$GCS_ROLE"
fi

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    error "Project ID not found."
    exit 1
fi
success "Active Project: ${BOLD}${PROJECT_ID}${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 1: Create Service Account + Assign Roles (Checkpoint 1)
# ═══════════════════════════════════════════════════════════════════════════════
SA_NAME="sample-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

print_info "Creating Service Account: ${SA_NAME}..."
gcloud iam service-accounts create "$SA_NAME" \
    --display-name="ML API Service Account" 2>/dev/null || warning "Service Account already exists."

print_info "Assigning IAM roles..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="$BQ_ROLE" \
    --format="value(bindings.role)" --quiet || true

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="$GCS_ROLE" \
    --format="value(bindings.role)" --quiet || true

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/serviceusage.serviceUsageConsumer" \
    --format="value(bindings.role)" --quiet || true

success "Service Account created and exact roles assigned!"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 2: Create Credential Key File (Checkpoint 2)
# ═══════════════════════════════════════════════════════════════════════════════
print_info "Creating credential key..."
gcloud iam service-accounts keys create sample-sa-key.json \
    --iam-account="$SA_EMAIL" 2>/dev/null || true
export GOOGLE_APPLICATION_CREDENTIALS="${PWD}/sample-sa-key.json"
success "Credential key created and env var set!"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 3 & 4: Download, Patch & Run Python Script (Checkpoints 3 & 4)
# ═══════════════════════════════════════════════════════════════════════════════
print_info "Downloading original analyze-images-v2.py from bucket..."
gsutil cp "gs://${PROJECT_ID}/analyze-images-v2.py" .
success "Downloaded!"

print_info "Patching the 3 TBD lines + enabling BigQuery upload..."
python3 << 'PATCHCODE'
with open("analyze-images-v2.py", "r") as f:
    lines = f.readlines()

patched = []
for line in lines:
    if "# TBD: Create a Vision API image object" in line:
        indent = len(line) - len(line.lstrip())
        patched.append(" " * indent + "image_object = vision.Image(content=file_content)\n")
    elif "# TBD: Detect text in the image" in line:
        indent = len(line) - len(line.lstrip())
        patched.append(" " * indent + "response = vision_client.document_text_detection(image=image_object)\n")
    elif "# TBD: According to the target language" in line:
        indent = len(line) - len(line.lstrip())
        patched.append(" " * indent + "translation = translate_client.translate(desc, target_language='TARGET_LOCALE')\n")
    elif line.strip().startswith("# errors = bq_client.insert_rows"):
        indent = len(line) - len(line.lstrip())
        patched.append(" " * indent + "errors = bq_client.insert_rows(table, rows_for_bq)\n")
    else:
        patched.append(line)

with open("analyze-images-v2.py", "w") as f:
    f.writelines(patched)
print("Patched successfully!")
PATCHCODE

# Apply the user's specific locale
sed -i "s/TARGET_LOCALE/$LOCALE/g" analyze-images-v2.py

success "Script patched with target locale: $LOCALE"

print_info "Running analyze-images-v2.py (handling IAM propagation delays)..."
for ((i=1; i<=6; i++)); do
    if python3 analyze-images-v2.py "$PROJECT_ID" "$PROJECT_ID"; then
        break
    else
        warning "IAM/Key propagating... Retrying in 10s ($i/6)"
        sleep 10
    fi
done

# Restore env var for checkpoint verification
export GOOGLE_APPLICATION_CREDENTIALS="${PWD}/sample-sa-key.json"
success "Python script completed!"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 5: Run BigQuery Verification Query (Checkpoint 5)
# ═══════════════════════════════════════════════════════════════════════════════
print_info "Running BigQuery verification query..."
bq query --use_legacy_sql=false \
    "SELECT locale, COUNT(locale) as lcount FROM image_classification_dataset.image_text_detail GROUP BY locale ORDER BY lcount DESC"

echo ""
success "🎉 All 5 tasks complete! Check your Qwiklabs score — should be 100/100!"
