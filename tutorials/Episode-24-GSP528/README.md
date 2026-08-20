# Connecting Cloud Networks with NCC: Challenge Lab (GSP528)

Welcome to the Juni Labs tutorial for **Connecting Cloud Networks with NCC: Challenge Lab**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to fully automate the lab and get 100/100 points!

```bash
curl -sL "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-24-GSP528/quicklab.sh" -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 What this script does:
This script intelligently extracts pre-provisioned resource IDs from the lab environment and establishes a full Hub-and-Spoke connectivity model using the Network Connectivity Center (NCC):
1. Creates a central NCC hub named `global-hub`.
2. **Task 1:** Discovers the pre-configured VPN tunnels for `office-1` and `office-2` and creates two VPN spokes (`office-1-vpn-spoke`, `office-2-vpn-spoke`) with Site-to-Site data transfer enabled.
3. **Task 2:** Identifies Workload VPC 1 and Workload VPC 2, attaching them as VPC spokes. To fulfill naming constraints across tasks, Workload VPC 1's spoke is strategically named `hybrid-workload-1-spoke` and Workload VPC 2 is `workload-2-spoke`.
4. **Task 3:** Attaches the On-Prem Office 1 VPC as a hybrid VPC spoke named `hybrid-office-1-vpc-spoke`.

🎉 **Congratulations! You have completed the challenge lab!** Go back to the Qwiklabs instructions page and click all the **Check my progress** buttons to collect your points!
