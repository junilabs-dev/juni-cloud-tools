# Develop GenAI Apps with Gemini and Streamlit: Challenge Lab (GSP517)

## 🔗 YouTube Tutorial
[![YouTube Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?style=for-the-badge&logo=youtube)](https://youtu.be/YOUR_VIDEO_ID)

## 🚀 Quick Execution (Tasks 2, 3, 4, 5)
Run the following commands in your **Google Cloud Shell** to automate the infrastructure, Dockerization, and Cloud Run deployment tasks:

```bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-29-GSP517/quicklab.sh -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

> **⚠️ IMPORTANT FOR TASK 3:** At the end of the script, it will launch the local Streamlit server in the foreground. **Do not close it!** Go to Qwiklabs, click "Check Progress" for Task 3 to get your points, and then press `CTRL+C` in your terminal to stop it.

---

## 🤖 Task 1 (Jupyter Notebook Automation)
Task 1 requires executing the Gemini API call from within the Vertex AI Workbench notebook. We have fully automated this step for you.

1. In the Google Cloud Console, open the **Navigation Menu** and go to **Vertex AI > Workbench**.
2. Locate the `generative-ai-jupyterlab` instance and click **Open JupyterLab**.
3. In JupyterLab, click the **Terminal** icon from the Launcher tab.
4. Run the following commands to download our pre-solved notebook:
   ```bash
   rm prompt.ipynb
   curl -LO https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-29-GSP517/prompt.ipynb
   ```
5. Double-click to open the new `prompt.ipynb` from the left file browser.
6. From the top menu, select **Run > Run All Cells**.
7. Return to Qwiklabs and click **Check Progress** for Task 1!

🎉 **100% Score Guaranteed!**
