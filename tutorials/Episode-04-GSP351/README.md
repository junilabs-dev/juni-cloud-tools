# 🚀 GSP351: Migrate MySQL Data to Cloud SQL Using Database Migration Service

![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Cloud SQL](https://img.shields.io/badge/Cloud_SQL-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Database Migration Service](https://img.shields.io/badge/DMS-DB_Migration-669DF6?style=for-the-badge&logo=google-cloud&logoColor=white)

This directory contains the automation script and guide for the **Migrate MySQL Data to Cloud SQL Using Database Migration Service: Challenge Lab (GSP351)**.

## 🤖 Why is this a Hybrid Script?
The **Database Migration Service (DMS)** takes **10-15 minutes** to provision migration jobs and Cloud SQL instances. If we run this completely via a bash script, your Cloud Shell will hang for 20 minutes and might time out!

Instead, this script uses a **Smart Hybrid Approach**:
1. It instantly fetches all your hidden IP addresses and formats them for you.
2. It completely **automates Task 4** (which requires SSHing into a VM and running SQL commands).
3. It gives you a fast, click-by-click cheat sheet for the DMS UI.

## 🚀 How to Run

1. Open **Cloud Shell**.
2. Run the following commands:
   ```bash
   cd ~
   rm -rf juni-cloud-tools
   git clone https://github.com/junilabs-dev/juni-cloud-tools.git
   cd juni-cloud-tools/tutorials/Episode-04-GSP351
   chmod +x setup.sh
   ./setup.sh
   ```

---

## ✋ Manual UI Steps for Tasks 1, 2, 3, 5

The script will give you the **Source VM IP**. Use it to complete the UI steps:

### Task 1 & 2: One-Time Migration
1. Go to **Database Migration > Connection profiles** and click **CREATE PROFILE**.
   - Type: **MySQL**
   - Name: `mysql-source`
   - Hostname: *(Paste the IP given by the script)*
   - Username: `admin` | Password: `changeme`
   - Region: *(Select your lab region)*
2. Go to **Migration jobs** and click **CREATE MIGRATION JOB**.
   - Name: *(Copy from Qwiklabs Task 2)*
   - Source: `mysql-source`
   - Destination: Select the **Existing instance** provided in Qwiklabs.
   - Connectivity: **IP allowlist**
3. Click **TEST JOB** then **CREATE & START JOB**. Wait for it to complete.

### Task 3: Continuous Migration (VPC Peering)
1. Create another **Migration Job**:
   - Name: *(Copy from Qwiklabs Task 3)*
   - Source: `mysql-source`
   - Destination: Select the **second** Existing instance.
   - Connectivity: **VPC Peering** -> Select `default` network.
2. Click **TEST JOB** then **CREATE & START JOB**. Wait until status is "Running".

### Task 4: Test Replication
- **🎉 ALREADY AUTOMATED!** Our `setup.sh` script automatically runs the SQL query on the source VM for you! Just wait 1 minute and click *Check my progress*.

### Task 5: Promote Instance
1. Go to **Database Migration > Migration jobs**.
2. Click on your Continuous Migration Job.
3. Click **PROMOTE** at the top.
4. Click *Check my progress*! 🎉

---
**Created with ❤️ by JuniLabs**
