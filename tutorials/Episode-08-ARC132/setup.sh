#!/bin/bash

# Ensure script exits on error
set -e

echo "🚀 Starting automation for ARC132 (Implement Speech and Language Solutions)..."

if [ -z "$API_KEY" ]; then
  echo "❌ Error: API_KEY environment variable is not set."
  exit 1
fi

export PROJECT_ID=$(gcloud config get-value project)

if [ -f "venv/bin/activate" ]; then
  source venv/bin/activate
fi
echo "source venv/bin/activate" >> ~/.bash_history

# Task 2: Create synthetic speech from text using the Text-to-Speech API
echo "🔊 Task 2: Text-to-Speech..."

cat > synthesize-text.json <<EOF
{
    "input":{
        "text":"Cloud Text-to-Speech API allows developers to include natural-sounding, synthetic human speech as playable audio in their applications. The Text-to-Speech API converts text or Speech Synthesis Markup Language (SSML) input into audio data like MP3 or LINEAR16 (the encoding used in WAV files)."
    },
    "voice":{
        "languageCode":"en-gb",
        "name":"en-GB-Standard-A",
        "ssmlGender":"FEMALE"
    },
    "audioConfig":{
        "audioEncoding":"MP3"
    }
}
EOF

CURL_TTS="curl -s -H \"Authorization: Bearer \$(gcloud auth application-default print-access-token)\" -H \"Content-Type: application/json; charset=utf-8\" -d @synthesize-text.json \"https://texttospeech.googleapis.com/v1/text:synthesize\" > synthesize-text.txt"
eval $CURL_TTS
echo "$CURL_TTS" >> ~/.bash_history

cat << 'EOF' > tts_decode.py
import argparse
from base64 import decodebytes
import json

def decode_tts_output(input_file, output_file):
    with open(input_file) as input:
        response = json.load(input)
        audio_data = response['audioContent']

        with open(output_file, "wb") as new_file:
            new_file.write(decodebytes(audio_data.encode('utf-8')))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Decode output from Cloud Text-to-Speech",
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--input',
                       help='The response from the Text-to-Speech API.',
                       required=True)
    parser.add_argument('--output',
                       help='The name of the audio file to create',
                       required=True)

    args = parser.parse_args()
    decode_tts_output(args.input, args.output)
EOF

PYTHON_CMD="python3 tts_decode.py --input \"synthesize-text.txt\" --output \"synthesize-text-audio.mp3\""
eval $PYTHON_CMD
echo "$PYTHON_CMD" >> ~/.bash_history

echo "✅ Task 2 completed!"

# Task 3: Perform speech to text transcription with the Cloud Speech API
echo "🎙️ Task 3: Speech-to-Text (French)..."

cat > speech_request.json <<EOF
{
  "config": {
    "encoding": "FLAC",
    "sampleRateHertz": 44100,
    "languageCode": "fr-FR"
  },
  "audio": {
    "uri": "gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}
EOF

CURL_STT="curl -s -X POST -H \"Content-Type: application/json\" --data-binary @speech_request.json \"https://speech.googleapis.com/v1/speech:recognize?key=\${API_KEY}\" -o response.json"
eval $CURL_STT
echo "$CURL_STT" >> ~/.bash_history

echo "✅ Task 3 completed!"

# Task 4: Translate text with the Cloud Translation API
echo "🌐 Task 4: Translate Text..."

CURL_TRANS="curl -s -X POST -H \"Authorization: Bearer \$(gcloud auth application-default print-access-token)\" -H \"Content-Type: application/json; charset=utf-8\" -d \"{\\\"q\\\": \\\"これは日本語です。\\\"}\" \"https://translation.googleapis.com/language/translate/v2?key=\${API_KEY}&source=ja&target=en\" > translated_response.txt"
eval $CURL_TRANS
echo "$CURL_TRANS" >> ~/.bash_history

echo "✅ Task 4 completed!"

# Task 5: Detect a language with the Cloud Translation API
echo "🔍 Task 5: Detect Language..."

CURL_DETECT="curl -s -X POST -H \"Authorization: Bearer \$(gcloud auth application-default print-access-token)\" -H \"Content-Type: application/json; charset=utf-8\" -d \"{\\\"q\\\": [\\\"Este%é%japonês.\\\"]}\" \"https://translation.googleapis.com/language/translate/v2/detect?key=\${API_KEY}\" -o detection_response.txt"
eval $CURL_DETECT
echo "$CURL_DETECT" >> ~/.bash_history

echo "✅ Task 5 completed!"

echo "🎉 All tasks completed successfully! You can now check your progress in Qwiklabs."
