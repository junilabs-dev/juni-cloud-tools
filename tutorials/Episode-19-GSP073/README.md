# Cloud Storage: Qwik Start - Google Cloud Console (GSP073)

Welcome to the Juni Labs tutorial for **Cloud Storage: Qwik Start - Google Cloud Console**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-19-GSP073/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates all the manual `gcloud storage` commands for the Cloud Console equivalent lab:
1. **Task 1:** Creates a Cloud Storage bucket using your Project ID with public access prevention disabled.
2. **Task 2:** Downloads a sample image (`kitten.png`) from the internet and uploads it to the bucket.
3. **Task 3:** Grants the `allUsers` principal the `Storage Object Viewer` role to make the bucket public.
4. **Task 4:** Creates a subfolder structure (`folder1/folder2/`) and uploads the image into it.
5. **Task 5:** Pauses so you can check your progress in the lab, and then cleans up the subfolder when you press Enter.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points before pressing Enter to finish the script!
