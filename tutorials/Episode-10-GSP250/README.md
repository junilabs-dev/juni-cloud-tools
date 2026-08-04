# Episode 10: Introduction to Google Chat Bots with Apps Script (GSP250)

This lab is a **100% GUI-based No-Code Lab**, which means it **cannot be automated using a script**. You have to perform the steps manually in your browser. Don't worry, the steps are very straightforward!

Here is the quick and easy manual guide to complete this lab and get 100/100.

## Step-by-Step Guide

### Task 1: Create the Chat App in Apps Script
1. Open the **Google Apps Script** online editor (link is in the lab instructions).
2. Under "Google Workspace add-on starters", click on **Chat app (Intermediate version)**.
3. At the top left, click on the name `Untitled project`.
4. Rename it to **`Friendly Bot`** and click Rename.

### Task 2: Configure OAuth Consent Screen
1. Go back to the **Google Cloud Console**.
2. From the Navigation Menu, go to **APIs & Services > OAuth consent screen**.
3. Click **Get Started** (or select Internal and click Create).
4. Fill in the following details:
   - **App name:** `Friendly Bot`
   - **User support email:** Select your provided Qwiklabs student email.
   - **Audience:** Select `Internal` and click Next.
   - **Developer contact information:** Paste your Qwiklabs student email again.
5. Click **Save and Continue** until the end, then click **Back to Dashboard**.

### Task 3: Link Project Number to Apps Script
1. In Google Cloud Console, click on the **Google Cloud Logo** at the top left to go to the Dashboard.
2. In the "Project Info" card, copy your **Project Number**.
3. Go back to the **Google Apps Script** tab.
4. Click on the **Project Settings** (the gear icon ⚙️ on the left menu).
5. Scroll down to "Google Cloud Platform (GCP) Project" and click **Change project**.
6. Paste the **Project Number** you copied and click **Set project**.

### Task 4: Deploy and Configure Google Chat API
1. In the **Apps Script** editor, click the blue **Deploy** button at the top right and select **Test deployments**.
2. Click the **Copy** button next to the **Head Deployment ID**. Click Done.
3. Return to the **Google Cloud Console**, go to **APIs & Services > Library**.
4. Search for **`Google Chat API`** and select it. (If it's not enabled, click Enable).
5. Click the **Configuration** tab.
6. Fill in the required fields:
   - **App name:** `Friendly Bot`
   - **Avatar URL:** `https://goo.gl/kv2ENA`
   - **Description:** `Apps Script lab bot`
   - **Functionality:** Check the box for `Join spaces and group conversations`
   - **Connection settings:** Check `Apps Script project` and paste the **Deployment ID** you copied earlier.
   - **Visibility:** Check the box for your student username.
7. Click **Save**.
8. After it saves, change the **App Status** drop-down at the top to **LIVE – available to users** and click **Save** again.

### Task 5: Test the Bot
1. Open **Google Chat** (chat.google.com).
2. Click **New chat** (or "Start a chat" / the plus icon next to Chat).
3. Search for **`Friendly bot`**.
4. Click on **Friendly Bot (Apps Script lab bot)** to open a Direct Message.
5. Send any message like `"Hello bot!"`.
6. The bot should reply back repeating what you said.

🎉 **That's it! Go back to the lab page and click "Check my progress" to get your score!**
