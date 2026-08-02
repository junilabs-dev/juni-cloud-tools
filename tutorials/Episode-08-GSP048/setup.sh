#!/bin/bash

# Ensure the script exits on any error
set -e

echo "🚀 Starting automation for GSP048 (Speech to Text Transcription with the Speech-to-Text API)..."

if [ -z "$API_KEY" ]; then
  echo "❌ Error: API_KEY environment variable is not set."
  echo "Please create an API key in the Cloud Console (APIs & Services > Credentials),"
  echo "then set it by running:"
  echo 'export API_KEY="your_api_key"'
  echo "After that, run this script again."
  exit 1
fi

# Task 2: Create your API request
echo "📝 Creating request.json for English transcription..."
cat <<EOF > request.json
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/brooklyn_bridge.flac"
  }
}
EOF

# Task 3: Call the Speech-to-Text API
echo "🎙️ Calling Speech-to-Text API (English)..."
curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json

# Small delay to ensure Cloud logs register the API call
sleep 2
echo ""
echo "✅ English transcription complete! result.json now contains the English results."
echo "🛑 IMPORTANT: Go to Qwiklabs and click 'Check my progress' for the first THREE tasks NOW."
read -p "👉 Press [ENTER] only AFTER you get the green checkmarks..."

# Task 4: Speech-to-Text transcription in different languages
echo "📝 Updating request.json for French transcription..."
cat <<EOF > request.json
 {
  "config": {
      "encoding":"FLAC",
      "languageCode": "fr"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}
EOF

echo "🎙️ Calling Speech-to-Text API (French)..."
curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json

sleep 2
echo "✅ French transcription complete!"

echo "🎉 All tasks completed successfully! You can now check your progress in Qwiklabs."
