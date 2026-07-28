# Getting Started with gcloud

## 1. Install Google Cloud SDK

Run our installation script or install manually from Google:
```bash
./bash/install-sdk.sh
```

## 2. Authenticate

```bash
gcloud auth login
```

## 3. Set Project

```bash
gcloud config set project [YOUR_PROJECT_ID]
```

## 4. Default Region/Zone (Optional)

```bash
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```
