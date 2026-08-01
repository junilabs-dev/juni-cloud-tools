# Episode 07: Integrate BigQuery Data and Google Workspace using Apps Script (ARC133)

This is a comprehensive guide to completing the **ARC133** Google Cloud Skills Boost Challenge Lab.
Since this lab involves working directly within Google Sheets and Apps Script, there is no Cloud Shell automation script. Simply follow these steps and copy-paste the provided code and formulas.

## 🎯 Task 1: Query BigQuery and log the results to Google Sheets

1. Go to `script.google.com` (ensure you are signed in with your Qwiklabs student account).
2. Click **New Project** and rename it to anything (e.g., "BigQuery Integration").
3. Delete the default code in `Code.gs` and paste the following code:

```javascript
/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Filename for data results
var QUERY_NAME = "Most common words in all of Shakespeare's works";
var PROJECT_ID = "REPLACE_WITH_YOUR_PROJECT_ID"; // <--- CHANGE THIS TO YOUR QWIKLABS PROJECT ID
if (!PROJECT_ID) throw Error('Project ID is required in setup');

/**
 * Runs a BigQuery query; puts results into Sheet. You must enable
 * the BigQuery advanced service before you can run this code.
 */
function runQuery() {
  var request = {
    query:
        'SELECT ' +
            'LOWER(word) AS word, ' +
            'SUM(word_count) AS count ' +
        'FROM [bigquery-public-data:samples.shakespeare] ' +
        'GROUP BY word ' +
        'ORDER BY count ' +
        'DESC LIMIT 10'
  };
  var queryResults = BigQuery.Jobs.query(request, PROJECT_ID);
  var jobId = queryResults.jobReference.jobId;

  var sleepTimeMs = 500;
  while (!queryResults.jobComplete) {
    Utilities.sleep(sleepTimeMs);
    sleepTimeMs *= 2;
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId);
  }

  var rows = queryResults.rows;
  while (queryResults.pageToken) {
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId, {
      pageToken: queryResults.pageToken
    });
    rows = rows.concat(queryResults.rows);
  }

  if (!rows) {
    return Logger.log('No rows returned.');
  }

  var spreadsheet = SpreadsheetApp.create(QUERY_NAME);
  var sheet = spreadsheet.getActiveSheet();

  var headers = queryResults.schema.fields.map(function(field) {
    return field.name.toUpperCase();
  });
  sheet.appendRow(headers);

  var data = new Array(rows.length);
  for (var i = 0; i < rows.length; i++) {
    var cols = rows[i].f;
    data[i] = new Array(cols.length);
    for (var j = 0; j < cols.length; j++) {
      data[i][j] = cols[j].v;
    }
  }

  var START_ROW = 2;
  var START_COL = 1;
  sheet.getRange(START_ROW, START_COL, rows.length, headers.length).setValues(data);

  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
}
```

4. **Important**: Replace `"REPLACE_WITH_YOUR_PROJECT_ID"` on line 17 with your actual GCP Project ID.
5. Rename the file to `bq-sheets.gs` and save.
6. Click **Services** (the `+` icon) on the left panel, scroll down, select **BigQuery API**, and click **Add**.
7. Click **Run** on the top menu. (Review permissions and allow them).
8. Click **Check my progress** in Qwiklabs for Task 1.

---

## 🎯 Task 2: Perform calculations on charts with Connected Sheets

1. Go to `sheets.google.com` and create a new **Blank Spreadsheet**.
2. Go to **Data > Data connectors > Connect to BigQuery**.
3. Select your **Project ID**, then go to `Public datasets` > `chicago_taxi_trips` > `taxi_trips`. Click **Connect**.
4. Once connected, open a new blank sheet tab in the same document.
5. Paste the following formulas into any cells (wait for the "Apply" prompt and click it for each):

**Find out how many taxi companies there are in Chicago:**
```excel
=COUNTUNIQUE(taxi_trips!company)
```

**Find the percentage of taxi rides in Chicago that included a tip:**
```excel
=COUNTIF(taxi_trips!tips,">0")
```

**Find the total number of trips where the fare was greater than 0:**
```excel
=COUNTIF(taxi_trips!fare,">0")
```

6. Click **Check my progress** in Qwiklabs for Task 2.

---

## 🎯 Task 3: Use Google Charts with Connected Sheets

You need to create specific charts on the connected `taxi_trips` data. Go back to the `taxi_trips` tab (Connected Sheet).

1. **Pie Chart (Payment Types)**
   - Click the **Chart** button inside the Connected Sheet UI.
   - For **Chart type**, choose **Pie chart**.
   - For **Label** (or Category), choose `payment_type`.
   - For **Value**, choose `payment_type` (Count).
   - Click **Apply**.

2. **Line Chart 1 (Mobile Payments over time)**
   - Click the **Chart** button again.
   - Choose **Line chart**.
   - For **X-axis**, choose `trip_start_timestamp` (Group by: Year-Month).
   - For **Series**, choose `fare` (Sum).
   - Under **Filter**, click Add > `payment_type`. Set it to: **Text contains `Mobile`**.
   - Click **Apply**.

3. **Line Chart 2 (Mobile payments after 2015)**
   - Copy the previous line chart.
   - Edit the chart and add a new **Filter**.
   - Select `trip_start_timestamp` and set condition: **After > Exact date > 12/31/2015** (or adjust depending on the UI prompt).
   - Click **Apply**.

4. Click **Check my progress** in Qwiklabs for Task 3.

---

## 🎯 Task 4: Use Apps Script to create a new worksheet and enter data

1. In Google Sheets, click the `+` button at the bottom left to create a completely new blank sheet (e.g., `Sheet2`).
2. Click on cell **A1**.
3. Paste the following exact text:
   `76 9th Ave, New York`
4. Press Enter.
5. Click **Check my progress** in Qwiklabs for Task 4.

🎉 **Lab Completed!**
