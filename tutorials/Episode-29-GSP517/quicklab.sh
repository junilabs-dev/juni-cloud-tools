#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP517 - Develop GenAI Apps with Gemini and Streamlit: Challenge Lab..."

PROJECT_ID=$(gcloud config get-value project)
echo ""
read -p "Enter the REGION (e.g. us-east1, us-central1) from your lab details: " REGION

# Task 1: Use cURL to test a prompt with the API
print_info "🚀 Task 1: Use cURL to test a prompt with the API"
gcloud services enable aiplatform.googleapis.com

print_info "⏳ Waiting for API to enable..."
sleep 15

TOKEN=$(gcloud auth print-access-token)
curl -s -X POST \
-H "Authorization: Bearer ${TOKEN}" \
-H "Content-Type: application/json" \
https://${REGION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${REGION}/publishers/google/models/gemini-1.5-flash:generateContent \
-d '{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "I am a Chef. I need to create Japanese recipes for customers who want low sodium meals. However, I do not want to include recipes that use ingredients associated with a peanuts food allergy. I have ahi tuna, fresh ginger, and edamame in my kitchen and other ingredients. The customer wine preference is red. Please provide some for meal recommendations. For each recommendation include preparation instructions, time to prepare and the recipe title at the beginning of the response. Then include the wine paring for each recommendation. At the end of the recommendation provide the calories associated with the meal and the nutritional facts."
        }
      ]
    }
  ]
}' > /dev/null 2>&1

print_info "✅ cURL request sent!"

# Task 2: Write Streamlit framework and prompt Python code
print_info "🚀 Task 2: Setting up repo and modifying chef.py"
git clone https://github.com/GoogleCloudPlatform/generative-ai.git
cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun
echo "google-cloud-logging" >> requirements.txt

# Download chef.py
curl -sL https://storage.googleapis.com/spls/gsp517/chef.py -o chef.py

# Use a python script to robustly patch chef.py
cat << 'EOF' > patch_chef.py
import sys

with open("chef.py", "r") as f:
    content = f.read()

# Add the wine radio button
content = content.replace(
    '# https://docs.streamlit.io/library/api-reference/widgets/st.radio',
    '# https://docs.streamlit.io/library/api-reference/widgets/st.radio\nwine = st.radio("Wine Preference", ["Red", "White", "None"])'
)

# Replace the prompt
new_prompt = '''prompt = f"""I am a Chef. I need to create {cuisine} \n recipes for customers who want {dietary_preference} meals. \n However, don't include recipes that use ingredients with the customer's {allergy} allergy. \n I have {ingredient_1}, \n {ingredient_2}, \n and {ingredient_3} \n in my kitchen and other ingredients. \n The customer's wine preference is {wine} \n Please provide some for meal recommendations. For each recommendation include preparation instructions, time to prepare and the recipe title at the beginning of the response. Then include the wine paring for each recommendation. At the end of the recommendation provide the calories associated with the meal and the nutritional facts. """'''
content = content.replace('prompt = f"""Why is the sky blue?"""', new_prompt)

# Hardcode the project and region to bypass any env variable mismatches
content = content.replace('os.environ.get("GCP_PROJECT")', f'"{sys.argv[1]}"')
content = content.replace('os.environ.get("GCP_REGION")', f'"{sys.argv[2]}"')

with open("chef.py", "w") as f:
    f.write(content)
EOF

python3 patch_chef.py "$PROJECT_ID" "$REGION"

# Upload to bucket
print_info "🚀 Uploading chef.py to Cloud Storage..."
gsutil cp chef.py gs://${PROJECT_ID}-generative-ai/

# Task 4: Modify Dockerfile and push to Artifact Registry
print_info "🚀 Task 4: Modifying Dockerfile and pushing to Artifact Registry"
sed -i 's/app.py/chef.py/g' Dockerfile
AR_REPO="chef-repo"
SERVICE_NAME="chef-streamlit-app"

gcloud artifacts repositories create $AR_REPO \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository" \
    --quiet || true

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" --quiet

# Task 5: Deploy the application to Cloud Run and test
print_info "🚀 Task 5: Deploying to Cloud Run"
gcloud run deploy $SERVICE_NAME \
    --port=8080 \
    --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
    --allow-unauthenticated \
    --region=$REGION \
    --platform=managed \
    --project=$PROJECT_ID \
    --set-env-vars=PROJECT=$PROJECT_ID,REGION=$REGION \
    --quiet

success "🎉 Lab GSP517 Complete!"
print_info "Click Check Progress for all tasks!"
