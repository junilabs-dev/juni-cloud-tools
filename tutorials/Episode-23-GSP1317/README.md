# Establish VPC to VPC Connectivity using NCC (GSP1317)

Welcome to the Juni Labs tutorial for **Establish VPC to VPC Connectivity using NCC**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-23-GSP1317/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script automates all the tasks required to build a hub-and-spoke network connectivity model:
1. **Task 1:** Creates a Network Connectivity Center (NCC) hub.
2. **Task 2:** Configures two VPCs (`vpc1-ncc` and `vpc2-ncc`) as NCC spokes.
3. **Task 4:** Automatically calculates a free IP, reserves an internal IP address, sets up Private Service Connect (PSC) pointing to a Cloud SQL instance, configures a DNS managed zone, and adds a DNS record.
4. **Task 5:** Automatically connects to the `cloudsql-client` VM via IAP and creates the required database (`company`) and table (`employees`) via `psql`.
5. **Task 6 (Cleanup):** After pausing to let you verify your points, it deletes the spokes, hub, and DNS records so you get the full end-to-end learning experience.

🎉 **Congratulations! You have completed the lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your 100 points!
