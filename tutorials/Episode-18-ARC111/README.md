# Implement Cloud Storage and Data Protection Solutions: Challenge Lab (ARC111)

Welcome to the Juni Labs tutorial for **Implement Cloud Storage and Data Protection Solutions: Challenge Lab**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!
*(Note: Because this is a challenge lab, the script will pause and ask you to copy-paste the names of Bucket 1, Bucket 2, and Bucket 3 from your Qwiklabs instruction panel).*

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-18-ARC111/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates the 3 dynamically assigned challenge tasks:
1. **Task 1:** Creates `Bucket1` with the `COLDLINE` storage class in your specific region.
2. **Task 2:** Updates the pre-created `Bucket2` by adding a data retention policy of `30s`.
3. **Task 3:** Creates a dummy file and uploads it to the pre-created `Bucket3`.

🎉 **Congratulations! You have completed the challenge lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
