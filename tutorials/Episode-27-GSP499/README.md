# User Authentication: Identity-Aware Proxy (GSP499)

Welcome to the Juni Labs tutorial for **User Authentication: Identity-Aware Proxy**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to automate the lab:

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-27-GSP499/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

### 🚨 Important Manual Steps

Identity-Aware Proxy (IAP) has an internal OAuth Consent Screen that cannot be fully automated via `gcloud`. Because of this, the script will pause halfway through and ask you to perform a few quick steps in the Google Cloud Console:

1. **Go to Security > Identity-Aware Proxy**.
2. **Turn ON** the IAP toggle for `user-auth-lab`.
3. Select `user-auth-lab` and click **Add Principal**.
4. Enter your Qwiklabs Student Email, and select Role: **Cloud IAP > IAP-Secured Web App User**.
5. Click the 3 dots next to `user-auth-lab` and click **Get JWT audience code**.
6. Copy the **Client ID** and paste it into the script when prompted.

Once you paste the Client ID, the script will finish the final deployment and give you 100/100 points! 🎉
