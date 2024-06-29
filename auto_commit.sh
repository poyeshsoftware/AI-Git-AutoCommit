#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Uncomment the following line in case you want to automatically add all the files to the commit
git add .

# Set the default AI service
AI_SERVICE="gemini" # options: groq, local, gemini
GROQ_AI_MODEL_NAME="llama3-70b-8192" # options: llama3-8b-8192, llama3-70b-8192
GEMINI_AI_MODEL_NAME="gemini-1.5-pro" # options: gemini-1.5-flash, gemini-1.5-pro, gemini-1.0-pro
LOCAL_AI_MODEL_NAME="codestral:latest" # options: codestral:latest, phi3:latest, llama3:latest

# Capture the git diff output
DIFF_OUTPUT=$(git diff --cached)

# Check if there are any staged changes
if [ -z "$DIFF_OUTPUT" ]; then
  echo "No changes staged for commit."
  exit 1
fi

# Common prompt parts
PROMPT_INTRO="Generate a commit message in JSON format for the following changes.
The JSON object should only contain two fields: 'commit_message' and 'files'.
Each file should have a 'file' and 'changes' field.
The 'changes' field should be a descriptive string summarizing the changes made on that exact same file and why we changed that.
Output only the JSON object, nothing else. The 'commit_message' field should not be empty and should provide a summary of the changes.
Do not include any explanations, examples, or any other text. Only output the JSON object."
PROMPT_BODY="Here are the changes:\n$DIFF_OUTPUT"

generate_commit_message_groq() {
  API_KEY="$GROQ_API_KEY"
  PROMPT="$PROMPT_INTRO\n\n$PROMPT_BODY"
  PAYLOAD=$(jq -n --arg prompt "$PROMPT" --arg model "$GROQ_AI_MODEL_NAME" '{"messages": [{"role": "user", "content": $prompt}], "model": $model}')

  RESPONSE=$(curl -s -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "$PAYLOAD")

  if [ $? -ne 0 ]; then
    echo "Error calling Groq API. Check if it's running and accessible."
    exit 1
  fi

  COMMIT_MESSAGE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content | fromjson | .commit_message')
  FILE_CHANGES_JSON=$(echo "$RESPONSE" | jq -r '.choices[0].message.content | fromjson | .files')
}

generate_commit_message_local() {
  PROMPT="$PROMPT_INTRO\n\n$PROMPT_BODY"
  PAYLOAD=$(jq -n --arg model "$LOCAL_AI_MODEL_NAME" \
                --arg prompt "$PROMPT" \
                --argjson stream false \
                --argjson options '{"num_ctx": 32768}' \
                '{model: $model, prompt: $prompt, stream: $stream, options: $options}')

  RESPONSE=$(curl -s http://localhost:11434/api/generate -d "$PAYLOAD")

  if [ $? -ne 0 ]; then
    echo "Error calling Ollama API. Check if it's running and accessible."
    exit 1
  fi

  COMMIT_MESSAGE=$(echo "$RESPONSE" | jq -r '.response' | sed 's/`json//g' | sed 's/`//g' | jq -r '.commit_message')
  FILE_CHANGES_JSON=$(echo "$RESPONSE" | jq -r '.response' | sed 's/`json//g' | sed 's/`//g' | jq '.files')
}

generate_commit_message_gemini() {
  API_KEY="$GEMINI_API_KEY"
  PROMPT="$PROMPT_INTRO\n\n$PROMPT_BODY"
  PAYLOAD=$(jq -n --arg text "$PROMPT" '{contents: [{"role": "user", "parts": [{"text": $text}]}]}')

  RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1/models/$GEMINI_AI_MODEL_NAME:generateContent?key=$API_KEY" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

  if [ $? -ne 0 ]; then
    echo "Error calling Gemini API. Check if it's running and accessible."
    exit 1
  fi

  ERROR_MESSAGE=$(echo "$RESPONSE" | jq -r '.error.message // empty')
  if [ -n "$ERROR_MESSAGE" ]; then
    echo "Error from Gemini API: $ERROR_MESSAGE"
    exit 1
  fi

  RESPONSE_TEXT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
  RESPONSE_TEXT=$(echo "$RESPONSE_TEXT" | sed 's/^```json//' | sed 's/```$//')
  COMMIT_MESSAGE=$(echo "$RESPONSE_TEXT" | jq -r '.commit_message')
  FILE_CHANGES_JSON=$(echo "$RESPONSE_TEXT" | jq -r '.files')
}

case "$AI_SERVICE" in
  groq)
    generate_commit_message_groq
    ;;
  local)
    generate_commit_message_local
    ;;
  gemini)
    generate_commit_message_gemini
    ;;
  *)
    echo "Invalid AI service specified."
    exit 1
    ;;
esac

if [ -z "$COMMIT_MESSAGE" ] || [ -z "$FILE_CHANGES_JSON" ]; then
  echo "Error: API response does not have the expected format."
  echo "Raw response: $RESPONSE"
  exit 1
fi

FILE_CHANGES=$(echo "$FILE_CHANGES_JSON" | jq -r '.[] | "\(.file): \(.changes)"')

COMMIT_MESSAGE="$COMMIT_MESSAGE"$'\n\n'"$FILE_CHANGES"

echo "Generated commit message:"
echo "$COMMIT_MESSAGE"

read -p "Do you want to use this commit message? (yes/no) " CONFIRM

if [ "$CONFIRM" = "yes" ] || [ "$CONFIRM" = "y" ]; then
  git commit -m "$COMMIT_MESSAGE"
  echo "Changes have been committed."
  git push
  echo "Changes have been pushed."
else
  echo "Commit aborted."
fi
