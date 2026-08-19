# Pub/Sub: Qwik Start - Command Line (GSP095)

Welcome to the Juni Labs tutorial for **Pub/Sub: Qwik Start - Command Line**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-21-GSP095/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates all the `gcloud pubsub` commands from the lab manual:
1. **Task 1:** Creates Pub/Sub topics (`myTopic`, `Test1`, `Test2`) and cleans up the test topics.
2. **Task 2:** Creates subscriptions (`mySubscription`, `Test1`, `Test2`) for the topic and cleans up the test subscriptions.
3. **Task 3 & 4:** Publishes multiple messages to the topic and successfully pulls them using the `--auto-ack` and `--limit` flags.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
