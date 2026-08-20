# Configuring IAM Permissions with gcloud (GSP647)

Welcome to the Juni Labs tutorial for **Configuring IAM Permissions with gcloud**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-26-GSP647/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

**Note:** The script will pause and ask you to enter two values from your Qwiklabs dashboard:
1. `Project ID 2`
2. `Username 2`

Please have them ready!

## 📝 What this script does:
This script intelligently completes all graded tasks by performing the following under the hood using `gcloud` (using the main admin account to avoid credential switching overhead):
1. **Task 1:** Creates a Compute Engine instance (`lab-1`) in Project 1.
2. **Task 3:** Assigns the `roles/viewer` role to Username 2 in Project 2.
3. **Task 4:** Creates a custom IAM role (`devops`) in Project 2 and binds it along with `roles/iam.serviceAccountUser` to Username 2. Creates the `lab-2` instance.
4. **Task 5 & 6:** Creates a service account (`devops`), binds necessary IAM roles to it (`roles/iam.serviceAccountUser` and `roles/compute.instanceAdmin`), and attaches it to a new `lab-3` VM.
5. **Task 7:** Creates the final `lab-4` VM in Project 2 to fulfill all Qwiklabs checkpoints.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
