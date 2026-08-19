#!/bin/bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/bash/utils.sh -o utils.sh
source utils.sh
print_banner
print_info "Starting ARC100 - Store, Process, and Manage Data on Google Cloud: Challenge Lab..."

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

print_info "====================================================="
print_info "PLEASE ENTER THE EXACT NAMES FROM YOUR QWIKLABS PANEL"
print_info "====================================================="
read -p "Enter Bucket Name: " BUCKET_NAME
read -p "Enter Topic Name: " TOPIC_NAME
read -p "Enter Cloud Run Function Name: " FUNCTION_NAME

if [ -z "$BUCKET_NAME" ] || [ -z "$TOPIC_NAME" ] || [ -z "$FUNCTION_NAME" ]; then
    error "Names cannot be empty. Please run the script again and provide all names."
    exit 1
fi

print_info "🚀 Enabling required APIs..."
gcloud services enable \
  run.googleapis.com \
  eventarc.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  pubsub.googleapis.com

print_info "🚀 Task 1: Creating Bucket ($BUCKET_NAME)..."
gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION || true

print_info "🚀 Task 2: Creating Pub/Sub topic ($TOPIC_NAME)..."
gcloud pubsub topics create $TOPIC_NAME || true

print_info "🚀 Task 3: Creating the thumbnail Cloud Run function..."
mkdir -p thumbnail_function
cd thumbnail_function

cat > index.js << EOF
const functions = require('@google-cloud/functions-framework');
const { Storage } = require('@google-cloud/storage');
const { PubSub } = require('@google-cloud/pubsub');
const sharp = require('sharp');

functions.cloudEvent('${FUNCTION_NAME}', async cloudEvent => {
  const event = cloudEvent.data;
  console.log(\`Event: \${JSON.stringify(event)}\`);
  console.log(\`Hello \${event.bucket}\`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64";
  const bucket = new Storage().bucket(bucketName);
  const topicName = "${TOPIC_NAME}";
  const pubsub = new PubSub();

  if (fileName.search("64x64_thumbnail") === -1) {
    const filename_split = fileName.split('.');
    const filename_ext = filename_split[filename_split.length - 1].toLowerCase();
    const filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length - 1);

    if (filename_ext === 'png' || filename_ext === 'jpg' || filename_ext === 'jpeg') {
      console.log(\`Processing Original: gs://\${bucketName}/\${fileName}\`);
      const gcsObject = bucket.file(fileName);
      const newFilename = \`\${filename_without_ext}_64x64_thumbnail.\${filename_ext}\`;
      const gcsNewObject = bucket.file(newFilename);

      try {
        const [buffer] = await gcsObject.download();
        const resizedBuffer = await sharp(buffer)
          .resize(64, 64, {
            fit: 'inside',
            withoutEnlargement: true,
          })
          .toFormat(filename_ext)
          .toBuffer();

        await gcsNewObject.save(resizedBuffer, {
          metadata: {
            contentType: \`image/\${filename_ext}\`,
          },
        });

        console.log(\`Success: \${fileName} → \${newFilename}\`);

        await pubsub
          .topic(topicName)
          .publishMessage({ data: Buffer.from(newFilename) });

        console.log(\`Message published to \${topicName}\`);
      } catch (err) {
        console.error(\`Error: \${err}\`);
      }
    } else {
      console.log(\`gs://\${bucketName}/\${fileName} is not an image I can handle\`);
    }
  } else {
    console.log(\`gs://\${bucketName}/\${fileName} already has a thumbnail\`);
  }
});
EOF

cat > package.json << 'EOF'
{
 "name": "thumbnails",
 "version": "1.0.0",
 "description": "Create Thumbnail of uploaded image",
 "scripts": {
   "start": "node index.js"
 },
 "dependencies": {
   "@google-cloud/functions-framework": "^3.0.0",
   "@google-cloud/pubsub": "^2.0.0",
   "@google-cloud/storage": "^6.11.0",
   "sharp": "^0.32.1"
 },
 "devDependencies": {},
 "engines": {
   "node": ">=4.3.2"
 }
}
EOF

print_info "Installing dependencies..."
npm install

print_info "Setting up IAM permissions for Eventarc..."
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud beta services identity create --service=pubsub.googleapis.com --project=$PROJECT_ID || true
gcloud beta services identity create --service=eventarc.googleapis.com --project=$PROJECT_ID || true

# Grant Pub/Sub Publisher role to Cloud Storage service account
STORAGE_SA=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$STORAGE_SA" \
  --role="roles/pubsub.publisher" || true

# Grant Eventarc Event Receiver to default compute service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
  --role="roles/eventarc.eventReceiver" || true

# Grant Service Account Token Creator to Pub/Sub Service Agent
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-pubsub.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator" || true

# Grant Eventarc Service Agent role to Eventarc Service Agent
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-eventarc.iam.gserviceaccount.com" \
  --role="roles/eventarc.serviceAgent" || true

print_info "Waiting 30 seconds for IAM permissions to fully propagate across Google Cloud..."
sleep 30

print_info "Deploying Cloud Run function (This takes about 2 minutes)..."
gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime nodejs22 \
  --region $REGION \
  --source . \
  --entry-point $FUNCTION_NAME \
  --trigger-bucket $BUCKET_NAME \
  --allow-unauthenticated \
  --quiet

print_info "🚀 Task 4: Testing the Infrastructure..."
curl -sL "https://storage.googleapis.com/cloud-training/arc101/travel.jpg" -o travel.jpg
gcloud storage cp travel.jpg gs://$BUCKET_NAME/

success "🎉 Lab ARC100 Challenge Complete!"
print_info "Go back to Qwiklabs and click all the 'Check my progress' buttons to get 100/100 points!"
