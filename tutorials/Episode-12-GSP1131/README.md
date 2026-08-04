# Episode 12: Artifact Registry: Qwik Start (GSP1131)

This lab is completely CLI-based, which means we can fully automate it using a single script! You can run this script directly in the **Google Cloud Shell**.

## Automated Solution

1. Start your lab in Qwiklabs.
2. Open the **Google Cloud Console**.
3. Activate the **Cloud Shell** (the terminal icon at the top right).
4. Run the following command in the Cloud Shell:

```bash
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-12-GSP1131/setup.sh?v=\$(date +%s)" -O setup.sh && chmod +x setup.sh && ./setup.sh
```

5. Wait for the script to finish. It will automatically detect your region, create the Docker repository, configure authentication, and handle pulling, tagging, and pushing the sample image.
6. Once the script says **"All tasks completed successfully!"**, go back to Qwiklabs and click **Check my progress** for all the tasks.

🎉 Enjoy your 100/100 points!
