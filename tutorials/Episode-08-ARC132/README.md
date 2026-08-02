# Episode 08: Implement Speech and Language Solutions with Pre-trained APIs (ARC132)

This is an automated solution for the Google Cloud Skills Boost challenge lab **ARC132**.

## Usage Instructions

1. Start the lab in Qwiklabs and open the **Google Cloud Console**.
2. **First, create your API Key:**
   - Go to **Navigation Menu > APIs & Services > Credentials**.
   - Click **Create Credentials** and select **API Key**.
   - Copy the generated API Key.
3. **Connect to the Compute Engine VM:**
   - Go to **Navigation Menu > Compute Engine > VM instances**.
   - Find the instance provisioned for you and click the **SSH** button next to it.
   - A new browser window with a terminal will open.
4. In this new SSH terminal, run the following command, making sure to replace `YOUR_API_KEY_HERE` with the key you just copied:

```bash
export API_KEY="YOUR_API_KEY_HERE"
```

5. Once the `API_KEY` is set, download and run the automated script by pasting this command:

```bash
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-08-ARC132/setup.sh?v=\$(date +%s)" -O setup.sh && chmod +x setup.sh && ./setup.sh
```

6. Wait for the script to say **"All tasks completed successfully!"**.
7. Go back to Qwiklabs and click **Check my progress** for all tasks.
