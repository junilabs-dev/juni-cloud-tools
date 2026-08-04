#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting automation for GSP1131 (Artifact Registry: Qwik Start)...${NC}"

# 1. Set Project ID
export PROJECT_ID=$(gcloud config get-value project)
echo -e "${GREEN}✅ Project ID set to: $PROJECT_ID${NC}"

# 2. Get Region
echo -e "${YELLOW}🔍 Detecting Region...${NC}"
REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)

if [ -z "$REGION" ]; then
    echo -e "${YELLOW}⚠️  Region not found in project metadata. Falling back to us-central1.${NC}"
    REGION="us-central1"
fi
echo -e "${GREEN}✅ Region set to: $REGION${NC}"

# 3. Create Docker repository
echo -e "${YELLOW}📦 Creating Docker repository 'example-docker-repo'...${NC}"
gcloud artifacts repositories create example-docker-repo --repository-format=docker \
    --location=$REGION --description="Docker repository" \
    --project=$PROJECT_ID

# 4. Configure authentication
echo -e "${YELLOW}🔐 Configuring authentication for Docker...${NC}"
gcloud auth configure-docker $REGION-docker.pkg.dev --quiet

# 5. Pull sample image
echo -e "${YELLOW}⬇️ Pulling sample image...${NC}"
docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

# 6. Tag the image
echo -e "${YELLOW}🏷️ Tagging image...${NC}"
docker tag us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0 \
    $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

# 7. Push the image
echo -e "${YELLOW}⬆️ Pushing image to Artifact Registry...${NC}"
docker push $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

# 8. Pull the image from AR
echo -e "${YELLOW}⬇️ Pulling image back from Artifact Registry...${NC}"
docker pull $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

echo -e "${GREEN}🎉 All tasks completed successfully! You can now check your progress in Qwiklabs.${NC}"
