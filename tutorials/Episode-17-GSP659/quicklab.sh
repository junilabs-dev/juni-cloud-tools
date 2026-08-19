#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP659 - Deploy Your Website on Cloud Run..."

export PROJECT_ID=$(gcloud config get-value project)
# Try to get region from config, then from project metadata
export REGION=$(gcloud config get compute/region 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
fi

if [ -z "$REGION" ]; then
    error "Could not automatically detect the region."
    read -p "Please enter the REGION from your Qwiklabs panel (e.g. us-east1): " REGION
fi

print_info "Using REGION: $REGION"

print_info "🚀 Task 1: Enabling APIs..."
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com run.googleapis.com

print_info "🚀 Task 2: Cloning the repository and installing dependencies..."
cd ~
rm -rf monolith-to-microservices
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices
./setup.sh

print_info "🚀 Task 3: Creating Artifact Registry Repository..."
gcloud artifacts repositories create monolith-demo \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository" || true

gcloud auth configure-docker $REGION-docker.pkg.dev --quiet

print_info "🚀 Task 4: Building the Docker image (v1.0.0)..."
cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:1.0.0

print_info "🚀 Task 5: Deploying to Cloud Run..."
gcloud run deploy monolith \
    --image $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:1.0.0 \
    --region $REGION \
    --allow-unauthenticated

print_info "🚀 Task 6: Creating new revision with lower concurrency (1)..."
gcloud run deploy monolith \
    --image $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:1.0.0 \
    --region $REGION \
    --concurrency 1 \
    --allow-unauthenticated

print_info "🚀 Task 7: Restoring concurrency to 80..."
gcloud run deploy monolith \
    --image $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:1.0.0 \
    --region $REGION \
    --concurrency 80 \
    --allow-unauthenticated

print_info "🚀 Task 8: Making changes to the website and rebuilding React app..."
cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js

cd ~/monolith-to-microservices/react-app
npm run build:monolith

print_info "🚀 Task 9: Building the updated Docker image (v2.0.0)..."
cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:2.0.0

print_info "🚀 Task 10: Deploying the updated website with zero downtime..."
gcloud run deploy monolith \
    --image $REGION-docker.pkg.dev/${PROJECT_ID}/monolith-demo/monolith:2.0.0 \
    --region $REGION \
    --allow-unauthenticated

success "🎉 Lab GSP659 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
