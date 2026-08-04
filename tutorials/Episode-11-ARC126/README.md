# Episode 11: Develop with Apps Script and AppSheet: Challenge Lab (ARC126)

This Challenge Lab combines **AppSheet** and **Apps Script**. Like the previous labs, it is heavily GUI-based and requires manual clicks in the browser. 

Here is your easy step-by-step guide to complete **ARC126** and get 100/100 points. 
**Note:** You can use the provided `ARC126-ATM-Maintenance.xlsx` as the source spreadsheet if needed for the AppSheet app!

---

## Task 1: Create and customize an AppSheet app
1. Log in to **AppSheet** (using the temporary Qwiklabs email).
2. Open the **ATM Maintenance app** (from the lab link).
3. Click **Copy app** on the left menu.
4. Set the **App name** to `ATM Maintenance Tracker` and click **Copy app**.
5. Once it loads, select **Chat apps** (chat icon) on the left menu.
6. Click **Create** -> **Next**.
7. Under the **Customize** card, expand **First message**.
8. Change the message text to: `Welcome to the ATM Maintenance Tracker app. What would you like to do today?`
9. Under **Actions**, click **+ New action** -> **Slash command: Open app view**.
10. Set **App View** to `Issues Reported By Me`.
11. Set **Name** to `/myissues`.
12. Set **Description** to `Lists tickets that include your email address`.
13. Click **Next** -> **Save** (at the top right).

*Click **Check my progress** for Task 1!*

---

## Task 2: Add an automation to an AppSheet app
1. Still in the AppSheet Chat app builder, under **Actions**, click **+ New action** -> **Build my own...**
2. Click **Configure event** -> **Create a new event**.
3. Set **Event name** to `New ticket`.
4. Set **Data change type** to `Adds only`.
5. Set **Table** to `Tickets`.
6. On the right panel, click **+ Add a step** -> **Create a new step** -> **New step**.
7. Click the **Send a chat message** icon (chat icon).
8. In the **Message Text** box, type exactly: `You have created a new ticket.`
9. **Save** your app at the top right.
10. In the **Test** panel or App Preview, create a New Ticket.
11. Set **First Name** to `Freeda` and fill in any value for ATM ID and Symptom.
12. Click **Save** in the app preview to trigger the automation.

*Click **Check my progress** for Task 2!*

---

## Task 3: Create and publish an Apps Script chat bot
*(If you need the code reference, see `Code.gs` in this repository).*

### Part A: Create Bot & Consent Screen
1. Open the **Google Apps Script** editor from the lab instructions.
2. Select **Chat app (Intermediate version)** under starters.
3. Rename the project to `Helper Bot` (click on "Untitled project" at top left).
4. Go to **Google Cloud Console** -> **Navigation Menu** -> **APIs & Services** -> **OAuth consent screen**.
5. Click **Get Started** / select **Internal**.
6. **App name**: `Helper Bot`
7. **User support email**: (Select your Qwiklabs email)
8. **Contact information**: (Paste your Qwiklabs email)
9. Click **Save and Continue** until done, then **Back to Dashboard**.

### Part B: Publish the Bot
1. Go back to Cloud Console dashboard and copy your **Project Number**.
2. In the **Apps Script** tab, go to **Project Settings** (⚙️).
3. Under Google Cloud Platform (GCP) Project, click **Change project**.
4. Paste the Project Number and click **Set project**.
5. Click the blue **Deploy** button (top right) -> **Test deployments**.
6. Copy the **Head Deployment ID** and click Done.
7. Back in **Google Cloud Console**, go to **APIs & Services > Library**.
8. Search for **`Google Chat API`** and select it (Enable if not already enabled).
9. Go to the **Configuration** tab and fill out:
   - **App name:** `Helper Bot`
   - **Avatar URL:** `https://goo.gl/kv2ENA`
   - **Description:** `Helper chat bot`
   - **Functionality:** Check `Join spaces and group conversations`.
   - **Connection settings:** Check `Apps Script project` and paste the **Deployment ID**.
   - **Visibility:** Check the box next to your username.
10. Click **Save**. Change the App Status drop-down at the top to **LIVE – available to users** and click **Save** again.

### Part C: Test the Bot
1. Open **Google Chat** (chat.google.com).
2. Click **Start a chat** (New chat).
3. Search for **`Helper Bot`** and select it.
4. Send any message like "Hello".

*Click **Check my progress** for Task 3 & 4!*

**Congratulations! 100/100 points!** 🚀
