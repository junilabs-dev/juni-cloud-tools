# Develop GenAI Apps with Gemini and Streamlit: Challenge Lab (GSP517)

## 🔗 YouTube Tutorial
[![YouTube Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?style=for-the-badge&logo=youtube)](https://youtu.be/YOUR_VIDEO_ID)

## 🚀 Quick Execution
Run the following commands in your Cloud Shell to automate the lab:
```bash
curl -sL https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-29-GSP517/quicklab.sh -o quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## ⚠️ Important Note for Task 1
The script automatically tests the Gemini API using `cURL` from your Cloud Shell, which often satisfies the grading check for Task 1. 

If Task 1 does **not** get a green checkmark, you will need to complete it manually:
1. In Google Cloud Console, go to **Vertex AI > Workbench**.
2. Click **Open JupyterLab** next to your instance.
3. Open the `prompt.ipynb` file.
4. In **Cell 5**, replace the `-d '{ ... }'` block (where it says "Why is the sky blue?") with the following exact payload:
```json
-d '{
  "contents": {
    "role": "USER",
    "parts": { "text": "I am a Chef. I need to create Japanese recipes for customers who want low sodium meals. However, I do not want to include recipes that use ingredients associated with a peanuts food allergy. I have ahi tuna, fresh ginger, and edamame in my kitchen and other ingredients. The customer wine preference is red. Please provide some for meal recommendations. For each recommendation include preparation instructions, time to prepare and the recipe title at the beginning of the response. Then include the wine paring for each recommendation. At the end of the recommendation provide the calories associated with the meal and the nutritional facts." }
  }
}'
```
5. Run all cells (`Run > Run All Cells`) and wait for the response to generate at the bottom.
6. **Save** the notebook (`File > Save Notebook`).
7. Click "Check my progress" for Task 1 on Qwiklabs.
