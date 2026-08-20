# Privileged Access with IAM: Challenge Lab (GSP526)

Welcome to the Juni Labs tutorial for the **Privileged Access with IAM: Challenge Lab**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to automate the lab:

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-28-GSP526/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

### 🚨 Important Manual Steps for PAM Approval

Privileged Access Manager (PAM) enforces a strict approval workflow that cannot be fully automated by a single user account. The script will pause halfway through and ask you to perform the approval and revocation steps manually using the **Secondary User** (Cymbal Security Lead).

1. Open a new Incognito window and log into the Google Cloud Console using **Username 2** and the lab password.
2. Search for **Privileged Access Manager** in the top search bar.
3. Go to the **Approvals** tab on the left, click on the pending request, and click **Approve**.
4. Wait about 10-20 seconds for the grant to become active.
5. Once active, go to the **Active Grants** tab (or stay on the same page) and click **Revoke**.
6. Check your Qwiklabs progress for Task 4 and 5. Once you get 100/100 for those tasks, go back to your original Cloud Shell window and press **Enter** to let the script finish cleaning up the environment (Task 6).

You should now have 100/100 points! 🎉
