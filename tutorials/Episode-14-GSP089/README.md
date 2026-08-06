# Cloud Monitoring: Qwik Start (GSP089)

Welcome to the Juni Labs tutorial for **Cloud Monitoring: Qwik Start**.

## 🎥 Video Tutorial
Watch the full step-by-step tutorial on YouTube: [Juni Labs](https://youtube.com/@junilabsdev) *(Video link coming soon!)*

## 🚀 Quick Setup

Run the following command in your Cloud Shell to automate the VM creation and agent installation (Tasks 1 & 2):

```bash
curl -LO raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-14-GSP089/quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## 📝 Manual Tasks (UI)

After the script finishes, wait 2-3 minutes for the startup script to complete the agent installation in the background. Then, follow these steps in the Google Cloud Console to get your remaining points:

### Task 3: Create an Uptime Check
1. Go to **Navigation menu > Monitoring > Uptime checks**.
2. Click **Create Uptime Check**.
3. **Protocol**: HTTP
4. **Resource Type**: URL
5. **Hostname**: Enter the External IP of your `lamp-1-vm`
6. **Check Frequency**: 1 minute
7. Click Continue, accept defaults for Response Validation and Alert & Notification.
8. **Title**: `Lamp Uptime Check`
9. Click **Test**, then **Create**.

### Task 4: Create an Alerting Policy
1. Go to **Monitoring > Alerting** and click **+ Create Policy**.
2. Click **Select a metric**. Uncheck "Active".
3. Search for `Network traffic` and select **VM instance > Interface > Network traffic (agent.googleapis.com/interface/traffic)**. Click Apply.
4. Click Next.
5. Set **Threshold position** to `Above threshold`.
6. Set **Threshold value** to `500`.
7. Expand **Advanced Options**, set **Retest window** to `1 min`. Click Next.
8. Uncheck "Use Notification Channels" or leave empty if not needed, or add an email if prompted. (The lab typically just checks the policy existence).
9. Set **Alert name** to `Inbound Traffic Alert`.
10. Click **Create Policy**.

### Task 5: Create a Dashboard (Optional for points, good for learning)
1. Go to **Monitoring > Dashboards** and click **+ Create Custom Dashboard**.
2. Name it `Cloud Monitoring LAMP Qwik Start Dashboard`.
3. Add a **Line** chart for `CPU load (1m)`.
4. Add another **Line** chart for `Received packets`.

🎉 **Congratulations! You have completed the lab and should have 100/100 points!**
