#!/bin/bash
source ../../bash/utils.sh
print_banner
print_info "Starting GSP1077 - PART 2..."

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION="us-central1"
fi
export REGION
export PATH=$PATH:~/.local/bin
GITHUB_USERNAME=$(gh api user -q ".login")

echo -e "${YELLOW}🔑 Granting Cloud Build access to GKE...${NC}"
gcloud projects add-iam-policy-binding ${PROJECT_NUMBER} \
--member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
--role=roles/container.developer

echo -e "${YELLOW}📁 Setting up hello-cloudbuild-env repository...${NC}"
cd ~
mkdir hello-cloudbuild-env
gcloud storage cp -r gs://spls/gsp1077/gke-gitops-tutorial-cloudbuild/* hello-cloudbuild-env/

cd hello-cloudbuild-env
sed -i "s/us-central1/$REGION/g" cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-delivery.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-trigger-cd.yaml
sed -i "s/us-central1/$REGION/g" kubernetes.yaml.tpl

ssh-keyscan -t rsa github.com > known_hosts.github
chmod +x known_hosts.github

git init
git config credential.helper gcloud.sh
git remote add google https://github.com/${GITHUB_USERNAME}/hello-cloudbuild-env.git
git branch -m master
git add . && git commit -m "initial commit"
git push google master

git checkout -b production

# Fetch and replace cloudbuild.yaml exactly as required for the ENV repo
cat << 'EOF' > cloudbuild.yaml
steps:
- name: 'gcr.io/cloud-builders/kubectl'
  id: Deploy
  args:
  - 'apply'
  - '-f'
  - 'kubernetes.yaml'
  env:
  - 'CLOUDSDK_COMPUTE_REGION='
  - 'CLOUDSDK_CONTAINER_CLUSTER=hello-cloudbuild'

- name: 'gcr.io/cloud-builders/git'
  secretEnv: ['SSH_KEY']
  entrypoint: 'bash'
  args:
  - -c
  - |
    echo "$$SSH_KEY" >> /root/.ssh/id_rsa
    chmod 400 /root/.ssh/id_rsa
    cp known_hosts.github /root/.ssh/known_hosts
  volumes:
  - name: 'ssh'
    path: /root/.ssh

- name: 'gcr.io/cloud-builders/git'
  args:
  - clone
  - --recurse-submodules
  - git@github.com:GITHUB_USERNAME_PLACEHOLDER/hello-cloudbuild-env.git
  volumes:
  - name: ssh
    path: /root/.ssh

- name: 'gcr.io/cloud-builders/gcloud'
  id: Copy to production branch
  entrypoint: /bin/sh
  args:
  - '-c'
  - |
    set -x && \
    cd hello-cloudbuild-env && \
    git config user.email $(gcloud auth list --filter=status:ACTIVE --format='value(account)')
    sed "s/GOOGLE_CLOUD_PROJECT/${PROJECT_ID}/g" kubernetes.yaml.tpl | \
    git fetch origin production && \
    git checkout production && \
    git checkout $COMMIT_SHA kubernetes.yaml && \
    git commit -m "Manifest from commit $COMMIT_SHA
    $(git log --format=%B -n 1 $COMMIT_SHA)" && \
    git push origin production
  volumes:
  - name: ssh
    path: /root/.ssh

availableSecrets:
  secretManager:
  - versionName: projects/PROJECT_NUMBER_PLACEHOLDER/secrets/ssh_key_secret/versions/1
    env: 'SSH_KEY'

options:
  logging: CLOUD_LOGGING_ONLY
EOF

sed -i "s/GITHUB_USERNAME_PLACEHOLDER/${GITHUB_USERNAME}/g" cloudbuild.yaml
sed -i "s/PROJECT_NUMBER_PLACEHOLDER/${PROJECT_NUMBER}/g" cloudbuild.yaml

git add .
git commit -m "Create cloudbuild.yaml for deployment"
git checkout -b candidate
git push google production
git push google candidate

echo -e "${YELLOW}📁 Pushing known_hosts to hello-cloudbuild-app...${NC}"
cd ~/hello-cloudbuild-app
ssh-keyscan -t rsa github.com > known_hosts.github
chmod +x known_hosts.github
git add .
git commit -m "Adding known_host file."
git push google master

echo -e "${GREEN}🎉 PART 2 COMPLETE!${NC}"
echo -e "${CYAN}========================================================================${NC}"
echo -e "${RED}ACTION REQUIRED: Create the 2nd Cloud Build Trigger for the ENV repo! (Task 6 in manual)${NC}"
echo -e "${YELLOW}After creating the Trigger in UI, run PART 3 to test the pipeline!${NC}"
