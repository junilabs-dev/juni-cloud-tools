# 📊 GSP375: Share Data using Google Data Cloud: Challenge Lab

![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-669DF6?style=for-the-badge&logo=google-cloud&logoColor=white)

This directory contains the automation script for the **Share Data using Google Data Cloud: Challenge Lab (GSP375)** by JuniLabs.

## 📝 Overview
In this lab, you act as both a **Data Sharing Partner** and a **Customer**. You are required to enable bi-directional data exchange in BigQuery by creating authorized views, granting specific IAM roles, updating datasets, and finally creating a Looker/Data Studio visualization.

## 🤖 What does this script automate?
Because Qwiklabs **randomizes** project IDs, usernames, and view names for every student, this script is fully interactive. It will ask you for the values provided in your Qwiklabs portal and automatically perform:
- **Task 1:** Create the partner authorized view & grant IAM permissions.
- **Task 2:** Update the customer data table using cross-project queries.
- **Task 3:** Create the customer authorized view & grant IAM permissions.

## 🚀 How to Run

1. Open **Cloud Shell** (Use the Primary/Partner account provided by Qwiklabs).
2. Run the following commands:
   ```bash
   cd ~
   rm -rf juni-cloud-tools
   git clone https://github.com/junilabs-dev/juni-cloud-tools.git
   cd juni-cloud-tools/tutorials/Episode-02-GSP375
   chmod +x setup.sh
   ./setup.sh
   ```
3. Enter the exact values when prompted by the script (found in your lab instructions panel).

> **Note:** If Task 2 fails with a "Permission Denied" error, it means Qwiklabs requires you to log in as the Customer. Simply open an Incognito Window, log in with the **Customer Credentials**, open Cloud Shell, and run this script again!

---

## ✋ Manual Steps Required (Task 4)
*Automating Google Data Studio (Looker Studio) via Cloud Shell is not possible because it's a completely UI-driven tool. You must do Task 4 manually.*

1. Go to [Google Looker Studio](https://datastudio.google.com/) and create a **Blank Report**.
2. Click **BigQuery** in the data connectors.
3. Select **My Projects** -> Select your **Customer Project ID** -> Select the **Customer Authorized View** you just created -> Click **Add**.
4. In the report:
   - Change the Report Name to `Data Sharing Partner Vizualization`.
   - Insert a **Vertical Bar Chart**.
   - Set **Dimension** to `county`.
   - Set **Breakdown Dimension** and **Metric** to `Count`.
5. Click **Check my progress** in Qwiklabs! 🎉

---
**Created with ❤️ by JuniLabs**
