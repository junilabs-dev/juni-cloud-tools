# 🚕 GSP327: Engineer Data for Predictive Modeling with BigQuery ML: Challenge Lab

![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-669DF6?style=for-the-badge&logo=google-cloud&logoColor=white)

This script automates the **GSP327** Challenge Lab. It extracts data, cleans it, trains a BigQuery Machine Learning (BQML) Linear Regression model, and performs batch predictions.

## 🚀 How to Run

1. Open **Google Cloud Shell** in your Qwiklabs environment.
2. Run the following command to clone the toolkit and execute the script:

```bash
cd ~
rm -rf juni-cloud-tools
git clone https://github.com/junilabs-dev/juni-cloud-tools.git
cd juni-cloud-tools/tutorials/Episode-04-GSP327
chmod +x setup.sh
./setup.sh
```

## 📝 Required Variables
When you run the script, it will ask for values that are **randomized** for every user. Look closely at your lab manual for:
*   The name of the new table to create (e.g. `taxi_training_data`)
*   The minimum trip distance (e.g. `1`, `2`)
*   The minimum fare amount (e.g. `2`, `3`)
*   The minimum passenger count (e.g. `1`, `2`)
*   The model name (usually `Fare`)

Sit back, relax, and let the script train your AI model and score 100%! 🎯
