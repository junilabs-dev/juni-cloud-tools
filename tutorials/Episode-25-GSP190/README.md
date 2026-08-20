# IAM Custom Roles (GSP190)

Welcome to the Juni Labs tutorial for **IAM Custom Roles**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-25-GSP190/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script intelligently completes all graded tasks for the IAM Custom Roles lab:
1. **Task 4:** Creates two custom IAM roles (`editor` and `viewer`) using a generated YAML definition file and gcloud CLI flags.
2. **Task 6:** Fetches the `ETAG` and updates the existing custom roles with least-privilege permissions (`storage.buckets.get` and `storage.buckets.list`).
3. **Task 7, 8 & 9:** Automates the lifecycle management of custom roles by disabling, deleting, and finally restoring the `viewer` custom role within the 7-day undelete window.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
