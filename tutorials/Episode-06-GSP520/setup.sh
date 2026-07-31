#!/bin/bash
# Automation Script for GSP520: Inspect Rich Documents with Gemini Multimodality and Multimodal RAG
# Provided by juni-cloud-tools

echo -e "\e[1;92m🚀 Starting GSP520 Automation... \e[0m"

echo -e "\e[1;96m[INFO] Downloading the solved notebook from juni-cloud-tools...\e[0m"
wget "https://raw.githubusercontent.com/junilabs-dev/juni-cloud-tools/main/tutorials/Episode-06-GSP520/juni-cloud-tools-gsp520.ipynb" -O juni-cloud-tools-gsp520.ipynb

echo -e "\e[1;92m[SUCCESS] Notebook downloaded successfully!\e[0m"
echo -e "\e[1;93m[ACTION REQUIRED]\e[0m"
echo -e "\e[1;97m1. Open the file 'juni-cloud-tools-gsp520.ipynb' from the left panel in JupyterLab.\e[0m"
echo -e "\e[1;97m2. Go to Edit -> Clear All Outputs.\e[0m"
echo -e "\e[1;97m3. Go to Run -> Run All Cells.\e[0m"
echo -e "\e[1;97m4. Wait for all cells to finish executing (this may take a few minutes).\e[0m"
echo -e "\e[1;97m5. Go back to Qwiklabs and click 'Check my progress' for all tasks!\e[0m"
