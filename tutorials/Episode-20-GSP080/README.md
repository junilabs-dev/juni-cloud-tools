# Cloud Run Functions: Qwik Start - Command Line (GSP080)

Welcome to the Juni Labs tutorial for **Cloud Run Functions: Qwik Start - Command Line**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!
*(Note: Deploying a Cloud Run function can take up to 2 minutes, so please be patient while the script runs.)*

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-20-GSP080/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates the creation and deployment of the Node.js function:
1. **Task 1:** Creates the required `index.js` and `package.json` files for the function and runs `npm install`.
2. **Task 2:** Deploys the function `nodejs-pubsub-function` as a Gen 2 Cloud Function with a Pub/Sub trigger topic `cf-demo`.
3. **Task 3 & 4:** Publishes a test message to the Pub/Sub topic to trigger the function and generate logs.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click the **Check my progress** button to collect your 100 points!
