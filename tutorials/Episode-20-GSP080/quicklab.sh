#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting GSP080 - Cloud Run Functions: Qwik Start - Command Line..."

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get compute/region 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
fi
if [ -z "$REGION" ]; then
    error "Could not automatically detect the region."
    read -p "Please enter the REGION from your Qwiklabs panel (e.g. us-east1): " REGION
fi
print_info "Using REGION: $REGION"

print_info "🚀 Task 1: Creating function files..."
mkdir -p gcf_hello_world
cd gcf_hello_world

cat > index.js << 'EOF'
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('helloPubSub', cloudEvent => {
  const base64name = cloudEvent.data.message.data;
  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World';
  console.log(`Hello, ${name}!`);
});
EOF

cat > package.json << 'EOF'
{
  "name": "gcf_hello_world",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
EOF

npm install

print_info "🚀 Task 2: Deploying the Cloud Run function (This takes 1-2 minutes)..."

# Some labs miss creating the stage bucket, we ensure it exists
gsutil ls gs://${PROJECT_ID}-bucket || gsutil mb gs://${PROJECT_ID}-bucket

gcloud functions deploy nodejs-pubsub-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=$REGION \
  --source=. \
  --entry-point=helloPubSub \
  --trigger-topic cf-demo \
  --stage-bucket ${PROJECT_ID}-bucket \
  --service-account cloudfunctionsa@${PROJECT_ID}.iam.gserviceaccount.com \
  --allow-unauthenticated \
  --quiet

print_info "🧪 Task 3 & 4: Testing the function and triggering Pub/Sub..."
gcloud pubsub topics publish cf-demo --message="Cloud Function Gen2"

success "🎉 Lab GSP080 Setup Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
