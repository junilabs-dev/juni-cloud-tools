# Store, Process, and Manage Data on Google Cloud: Challenge Lab (ARC100)

Welcome to the Juni Labs tutorial for **Store, Process, and Manage Data on Google Cloud: Challenge Lab**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!
*(Note: Because this is a challenge lab, the script will pause and ask you to copy-paste the names of the Bucket, Topic, and Cloud Run Function from your Qwiklabs instruction panel).*

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-22-ARC100/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates all 4 dynamically assigned challenge tasks:
1. **Task 1:** Creates a Google Cloud Storage bucket for photographs.
2. **Task 2:** Creates a Pub/Sub topic to receive messages when thumbnails are created.
3. **Task 3:** Creates the `index.js` and `package.json` for the thumbnail generator, automatically injects your dynamically assigned `Topic Name` into the code, assigns all necessary IAM permissions (Eventarc, Pub/Sub Publisher, etc.), and deploys the Cloud Run Gen2 Function triggered by the bucket.
4. **Task 4:** Tests the infrastructure by downloading a sample image and uploading it to the bucket, which triggers the thumbnail generation.

🎉 **Congratulations! You have completed the challenge lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
