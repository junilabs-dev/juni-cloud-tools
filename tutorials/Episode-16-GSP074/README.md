# Cloud Storage: Qwik Start - CLI/SDK (GSP074)

Welcome to the Juni Labs tutorial for **Cloud Storage: Qwik Start - CLI/SDK**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points instantly!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-16-GSP074/quicklab-v2.sh" -o quicklab-v2.sh
sudo chmod +x quicklab-v2.sh
./quicklab-v2.sh
```

## 📝 What this script does:
This script automates all the manual `gcloud storage` commands:
1. **Task 1:** Creates a Cloud Storage bucket.
2. **Task 2-3:** Downloads the `ada.jpg` image and uploads it to the bucket.
3. **Task 4:** Copies the object into a subfolder (`image-folder/`) within the bucket.
4. **Task 5-6:** Lists the contents and details of the bucket.
5. **Task 7:** Makes the object publicly accessible using ACL grants.

**⚠️ IMPORTANT:** The script will PAUSE after Task 7. 
At this point, you must go to Qwiklabs and click **Check my progress** for all checkpoints to get your 100 points.
After you get your points, press **Enter** in the terminal to let the script finish the cleanup tasks (removing public access and deleting the object).

🎉 **Congratulations! You have completed the lab!**
