#!/bin/bash
source ../../bash/utils.sh
print_banner
print_info "Starting GSP1077 - PART 3 (Pipeline Test)..."

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
export PATH=$PATH:~/.local/bin
GITHUB_USERNAME=$(gh api user -q ".login")

cd ~/hello-cloudbuild-app

cat << 'EOF' > cloudbuild.yaml
steps:
- name: 'python:3.7-slim'
  id: Test
  entrypoint: /bin/sh
  args:
  - -c
  - 'pip install flask && python test_app.py -v'

- name: 'gcr.io/cloud-builders/docker'
  id: Build
  args:
  - 'build'
  - '-t'
  - 'REGION_PLACEHOLDER-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:$SHORT_SHA'
  - '.'

- name: 'gcr.io/cloud-builders/docker'
  id: Push
  args:
  - 'push'
  - 'REGION_PLACEHOLDER-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:$SHORT_SHA'

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
  id: Change directory
  entrypoint: /bin/sh
  args:
  - '-c'
  - |
    cd hello-cloudbuild-env && \
    git checkout candidate && \
    git config user.email $(gcloud auth list --filter=status:ACTIVE --format='value(account)')
  volumes:
  - name: ssh
    path: /root/.ssh

- name: 'gcr.io/cloud-builders/gcloud'
  id: Generate manifest
  entrypoint: /bin/sh
  args:
  - '-c'
  - |
     sed "s/GOOGLE_CLOUD_PROJECT/${PROJECT_ID}/g" kubernetes.yaml.tpl | \
     sed "s/COMMIT_SHA/${SHORT_SHA}/g" > hello-cloudbuild-env/kubernetes.yaml
  volumes:
  - name: ssh
    path: /root/.ssh

- name: 'gcr.io/cloud-builders/gcloud'
  id: Push manifest
  entrypoint: /bin/sh
  args:
  - '-c'
  - |
    set -x && \
    cd hello-cloudbuild-env && \
    git add kubernetes.yaml && \
    git commit -m "Deploying image REGION_PLACEHOLDER-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:${SHORT_SHA}
    Built from commit ${COMMIT_SHA} of repository hello-cloudbuild-app
    Author: $(git log --format='%an <%ae>' -n 1 HEAD)" && \
    git push origin candidate
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

REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION="us-central1"
fi
sed -i "s/REGION_PLACEHOLDER/${REGION}/g" cloudbuild.yaml
sed -i "s/GITHUB_USERNAME_PLACEHOLDER/${GITHUB_USERNAME}/g" cloudbuild.yaml
sed -i "s/PROJECT_NUMBER_PLACEHOLDER/${PROJECT_NUMBER}/g" cloudbuild.yaml

git add cloudbuild.yaml
git commit -m "Trigger CD pipeline"
git push google master

echo -e "${YELLOW}🔁 Updating app to 'Hello Cloud Build' to trigger full end-to-end pipeline...${NC}"
sed -i 's/Hello World/Hello Cloud Build/g' app.py
sed -i 's/Hello World/Hello Cloud Build/g' test_app.py

git add app.py test_app.py
git commit -m "Hello Cloud Build"
git push google master

echo -e "${GREEN}🎉 ALL SCRIPTS FINISHED! Now just do Task 9 (Test Rollback) in the UI to get your 100/100 points!${NC}"
