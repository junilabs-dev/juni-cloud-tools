#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP499 - User Authentication: Identity-Aware Proxy..."

PROJECT_ID=$(gcloud config get-value project)
USER_EMAIL=$(gcloud config get-value account)
read -p "Enter Region (e.g. us-central1): " REGION

print_info "🚀 Setting up the environment..."
gcloud config set compute/region $REGION
gcloud config set run/region $REGION

print_info "🚀 Enabling IAP API..."
gcloud services enable iap.googleapis.com --quiet || true

# Task 1 & 2
print_info "🚀 Deploying Cloud Run Service (Tasks 1 & 2)..."
mkdir -p ~/user-authentication-with-iap/2-HelloUser
cd ~/user-authentication-with-iap/2-HelloUser

cat > main.py << 'EOF'
import os
from flask import Flask, request
app = Flask(__name__)
@app.route('/')
def index():
    return "Hello World!"
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
EOF

cat > requirements.txt << 'EOF'
Flask==3.0.0
EOF

gcloud run deploy user-auth-lab --source . --allow-unauthenticated --region=$REGION --quiet || true

print_info "======================================================"
print_info "🚨 MANUAL STEPS REQUIRED 🚨"
print_info "1. Go to Google Cloud Console -> Security -> Identity-Aware Proxy"
print_info "2. Turn ON the toggle for 'user-auth-lab'"
print_info "3. Select 'user-auth-lab' and click 'Add Principal' on the right"
print_info "4. Enter your email: $USER_EMAIL"
print_info "5. Select Role: Cloud IAP > IAP-Secured Web App User"
print_info "6. Click Save."
print_info "7. Click the 3 dots next to 'user-auth-lab' -> Get JWT audience code"
print_info "8. Copy the Client ID string."
print_info "======================================================"

read -p "Paste the Client ID string here: " CLIENT_ID

# Task 3
print_info "🚀 Deploying Task 3 (HelloVerifiedUser)..."
mkdir -p ~/user-authentication-with-iap/3-HelloVerifiedUser
cd ~/user-authentication-with-iap/3-HelloVerifiedUser

cat > main.py << 'EOF'
import os
from flask import Flask, request
app = Flask(__name__)
@app.route('/')
def index():
    return "Verified!"
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
EOF

cat > requirements.txt << 'EOF'
Flask==3.0.0
EOF

gcloud run deploy user-auth-lab --source . --set-env-vars IAP_AUDIENCE="$CLIENT_ID" --region=$REGION --quiet || true

print_info "🚀 Granting IAP service agent run.invoker role..."
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud run services add-iam-policy-binding user-auth-lab \
    --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-iap.iam.gserviceaccount.com" \
    --role="roles/run.invoker" \
    --region=$REGION --quiet || true

success "🎉 Lab GSP499 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons!"
