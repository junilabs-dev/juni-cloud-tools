# Episode 13: Google Kubernetes Engine Pipeline using Cloud Build (GSP1077)

This lab is very complex and requires your personal GitHub account to authenticate with Google Cloud Build. Because of the external browser-based authentication steps, **it cannot be fully automated into a single click.**

However, to make this as easy as possible, I have split the automation into 3 scripts. You just need to run the scripts and do the mandatory UI clicks in between!

---

## 🚀 Step 1: Run PART 1

Open the **Google Cloud Shell** in your Qwiklabs environment and run:

```bash
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-13-GSP1077/part1.sh" -O part1.sh && chmod +x part1.sh && ./part1.sh
```

**⚠️ Important:** During this script, you will be prompted to login to GitHub via the CLI. 
- Select **GitHub.com**
- Select **HTTPS**
- Type **Y**
- Select **Login with a web browser**. 
- Copy the 8-digit code, click the link, and authorize your GitHub account.

---

## 🖱️ Step 2: Manual UI Tasks (Required)

After `part1.sh` finishes, you must do two things manually:

**1. Add the SSH Deploy Key to GitHub:**
- The script will output an SSH key at the very end. Copy it.
- Go to your GitHub Repo: `https://github.com/YOUR_USERNAME/hello-cloudbuild-env/settings/keys`
- Click **Add deploy key**.
- **Title:** `SSH_KEY`
- **Key:** (Paste the key)
- ✅ **Check the box** that says `Allow write access`.
- Click **Add key**.

**2. Create the FIRST Cloud Build Trigger (Task 4):**
- Go back to Google Cloud Console -> **Cloud Build** -> **Triggers** -> **Create Trigger**.
- **Name:** `hello-cloudbuild`
- **Event:** `Push to a branch`
- **Source:** Click `Connect new repository` -> select GitHub -> Authorize the Google Cloud Build App for BOTH repositories (`hello-cloudbuild-app` and `hello-cloudbuild-env`).
- Select the **`hello-cloudbuild-app`** repository.
- **Branch:** `.* (any branch)`
- **Configuration:** `Cloud Build configuration file (yaml or json)` -> Location: `/ cloudbuild.yaml`
- **Service account:** `Compute Engine default service account`
- Click **Create**.

*(Click Check my progress for Task 4 in Qwiklabs)*

---

## 🚀 Step 3: Run PART 2

Back in your Google Cloud Shell, run:

```bash
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-13-GSP1077/part2.sh" -O part2.sh && chmod +x part2.sh && ./part2.sh
```

---

## 🖱️ Step 4: Manual UI Task (Required)

**1. Create the SECOND Cloud Build Trigger (Task 6):**
- Go back to Google Cloud Console -> **Cloud Build** -> **Triggers** -> **Create Trigger**.
- **Name:** `hello-cloudbuild-deploy`
- **Event:** `Push to a branch`
- **Source:** (Select GitHub, you are already connected)
- Select the **`hello-cloudbuild-env`** repository.
- **Branch:** `^candidate$`
- **Configuration:** `Cloud Build configuration file (yaml or json)` -> Location: `/ cloudbuild.yaml`
- **Service account:** `Compute Engine default service account`
- Click **Create**.

---

## 🚀 Step 5: Run PART 3

Run the final script in the Cloud Shell:

```bash
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-13-GSP1077/part3.sh" -O part3.sh && chmod +x part3.sh && ./part3.sh
```

This will trigger your entire end-to-end CI/CD pipeline! Wait a few minutes for the Cloud Build history to show the builds completing successfully.

---

## 🏁 Final Step (Task 9 - Rollback)

To get your final points, go to the **Cloud Build -> Dashboard**.
1. Look at the Build History for `hello-cloudbuild-env`.
2. Click on the **older** (second most recent) build.
3. Click the **Rebuild** button at the top.

Wait for it to finish, and click "Check my progress" for Task 9.
**Congratulations! 100/100 Points! 🎉**
