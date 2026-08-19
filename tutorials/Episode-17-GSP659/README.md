# Deploy Your Website on Cloud Run (GSP659)

Welcome to the Juni Labs tutorial for **Deploy Your Website on Cloud Run**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!
*(Note: Since this lab involves building Docker images and downloading node modules, the script might take 5-8 minutes to finish. Just sit back and relax!)*

```bash
curl -H 'Cache-Control: no-cache, no-store' -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-17-GSP659/quicklab.sh?t=$(date +%s)" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates all the manual `gcloud run` and `gcloud builds` commands:
1. **Task 1:** Enables necessary APIs (Cloud Build, Artifact Registry, Cloud Run).
2. **Task 2:** Clones the repository and installs node dependencies.
3. **Task 3:** Creates an Artifact Registry repository for Docker images.
4. **Task 4:** Submits a build to Cloud Build to containerize the `1.0.0` app.
5. **Task 5-7:** Deploys the container to Cloud Run, tests lower concurrency (`1`), and restores it (`80`).
6. **Task 8-9:** Modifies the React app homepage, rebuilds the static files, and creates a new `2.0.0` Docker image.
7. **Task 10:** Deploys the new `2.0.0` image to Cloud Run with zero downtime.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
