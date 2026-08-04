#!/bin/bash
source ../../bash/utils.sh
print_banner
print_info "Starting GSP1077 (Google Kubernetes Engine Pipeline using Cloud Build) - PART 1..."

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION="us-central1"
fi
export REGION
gcloud config set compute/region $REGION

echo -e "${GREEN}✅ Project: $PROJECT_ID | Region: $REGION${NC}"

echo -e "${YELLOW}🔄 Enabling APIs (This takes a moment)...${NC}"
gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com \
    secretmanager.googleapis.com \
    containeranalysis.googleapis.com

echo -e "${YELLOW}📦 Creating Artifact Registry...${NC}"
gcloud artifacts repositories create my-repository --repository-format=docker --location=$REGION || true

echo -e "${YELLOW}☸️ Creating GKE Cluster (This will take 3-5 minutes, please wait...)...${NC}"
# Use async so script doesn't hang completely, but we can't do that if next steps need it. 
# Actually, GKE creation blocks, but it's safer to wait.
gcloud container clusters create hello-cloudbuild --num-nodes 1 --region $REGION

echo -e "${YELLOW}🔑 Setting up GitHub CLI...${NC}"
curl -sS https://webi.sh/gh | sh
export PATH=$PATH:~/.local/bin

echo -e "${RED}⚠️ ATTENTION: Follow the prompt to login to GitHub.${NC}"
echo -e "${CYAN}Choose: GitHub.com -> HTTPS -> Y -> Login with a web browser${NC}"
gh auth login

GITHUB_USERNAME=$(gh api user -q ".login")
USER_EMAIL=$(gh api user -q ".email")
if [ -z "$USER_EMAIL" ] || [ "$USER_EMAIL" == "null" ]; then
    USER_EMAIL="$GITHUB_USERNAME@users.noreply.github.com"
fi

git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"

echo -e "${GREEN}✅ GitHub Authenticated as: $GITHUB_USERNAME${NC}"

echo -e "${YELLOW}📁 Creating and Cloning GitHub Repos...${NC}"
gh repo create hello-cloudbuild-app --private || true
gh repo create hello-cloudbuild-env --private || true

cd ~
rm -rf hello-cloudbuild-app hello-cloudbuild-env
git clone https://github.com/GoogleCloudPlatform/gke-gitops-tutorial-cloudbuild.git hello-cloudbuild-app
rm -rf hello-cloudbuild-app/.git

cd ~/hello-cloudbuild-app
sed -i "s/us-central1/$REGION/g" cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-delivery.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-trigger-cd.yaml
sed -i "s/us-central1/$REGION/g" kubernetes.yaml.tpl

git init
git config credential.helper gcloud.sh
git remote add google https://github.com/${GITHUB_USERNAME}/hello-cloudbuild-app.git
git branch -m master
git add . && git commit -m "initial commit"

echo -e "${YELLOW}🏗️ Building container image with Cloud Build...${NC}"
COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-cloudbuild:${COMMIT_ID}" .

echo -e "${YELLOW}🔐 Setting up SSH Keys for GitHub...${NC}"
cd ~
mkdir -p workingdir
cd workingdir
ssh-keygen -t rsa -b 4096 -N '' -f id_github -C "$USER_EMAIL"

echo -e "${YELLOW}🤫 Saving SSH Key to Secret Manager...${NC}"
gcloud secrets create ssh_key_secret --replication-policy="automatic" || true
gcloud secrets versions add ssh_key_secret --data-file=id_github

gcloud projects add-iam-policy-binding ${PROJECT_NUMBER} \
--member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
--role=roles/secretmanager.secretAccessor

echo -e "${GREEN}🎉 PART 1 COMPLETE!${NC}"
echo -e "${CYAN}========================================================================${NC}"
echo -e "${RED}ACTION REQUIRED: Copy the SSH Key below and add it to your GitHub Repo!${NC}"
echo -e "${YELLOW}"
cat id_github.pub
echo -e "${NC}"
echo -e "Go to: https://github.com/${GITHUB_USERNAME}/hello-cloudbuild-env/settings/keys"
echo -e "Click 'Add deploy key'. Title: SSH_KEY. Paste the key above."
echo -e "Check 'Allow write access' and click Add key."
echo -e "${CYAN}========================================================================${NC}"
echo -e "${GREEN}After adding the key and creating the Cloud Build Trigger for the APP repo (Task 4), run PART 2!${NC}"
