# 📊 GSP787: Derive Insights from BigQuery Data: Challenge Lab

![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-669DF6?style=for-the-badge&logo=google-cloud&logoColor=white)

This directory contains the automation script for the **Derive Insights from BigQuery Data: Challenge Lab (GSP787)** by JuniLabs.

## 📝 Overview
In this challenge lab, you are tasked with identifying answers to queries related to the Covid-19 pandemic using the public dataset `bigquery-public-data.covid19_open_data.covid19_open_data`. You need to write 9 BigQuery SQL queries to analyze confirmed cases, deaths, doubling rates, recovery rates, and CDGR.

## 🤖 What does this script automate?
Because Qwiklabs **randomizes all parameters (dates, death counts, limits, etc.)** for every student, this script is fully interactive! 
It will prompt you to enter the 13 specific variables from your lab instructions, and then it will **automatically execute all 9 BigQuery SQL queries** with 100% correct syntax and logic!

## 🚀 How to Run

1. Open **Cloud Shell**.
2. Run the following commands:
   ```bash
   cd ~
   rm -rf juni-cloud-tools
   git clone https://github.com/junilabs-dev/juni-cloud-tools.git
   cd juni-cloud-tools/tutorials/Episode-03-GSP787
   chmod +x setup.sh
   ./setup.sh
   ```
3. Enter the exact values when prompted by the script (found in your lab instructions panel). Make sure to enter dates exactly as requested (e.g., `2020-04-15`).

---

## ✋ Manual Steps Required (Task 10)
*Task 10 requires you to create a Data Studio (Looker Studio) report using the UI. This cannot be automated with a bash script.*

1. Go to [Google Looker Studio](https://datastudio.google.com/) and create a **Blank Report**.
2. Connect to **BigQuery** -> **Custom Query** -> Select your Project ID.
3. Paste the following query:
   ```sql
   SELECT date, SUM(cumulative_confirmed) AS country_cases, SUM(cumulative_deceased) AS country_deaths
   FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
   WHERE country_name = 'United States of America'
   AND date BETWEEN '2020-03-15' AND '2020-04-15' /* Replace with your lab's Date Range */
   GROUP BY date
   ```
4. Click **Add**.
5. Change the chart to a **Time series chart**.
6. Set **Dimension** to `date`.
7. Set **Metrics** to `country_cases` and `country_deaths`.
8. Click **Check my progress** in Qwiklabs! 🎉

---
**Created with ❤️ by JuniLabs**
