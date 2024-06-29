# AI-Git-AutoCommit

Automate your git commit messages using AI services like Groq, Local, and Gemini. This tool helps you maintain
consistent and descriptive commit messages with minimal effort.

## Features

- Supports multiple AI services: Groq, Local, and Gemini
- Automatically generates commit messages based on staged changes
- Easy setup and integration into existing workflows

## Setup

### Prerequisites

- Git
- Curl
- jq (Command-line JSON processor)
- Access to Groq, Local, or Gemini AI services and their respective API keys

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/AI-Git-AutoCommit.git
   cd AI-Git-AutoCommit
   ```
2. Install the necessary dependencies:

- Git
- Curl
- jq (Command-line JSON processor)
  for Mac OS:
   ```bash
    brew install git curl jq
   ```

for Ubuntu:

   ```bash
    sudo apt-get install git curl jq
   ```

2. Make the auto_commit.sh script executable:
   ```bash
   chmod +x auto_commit.sh
   ```
3. Create a .env file in the root directory of the repository and add your API keys:

```bash
   GROQ_API_KEY=your-groq-api-key
   GEMINI_API_KEY=your-gemini-api-key
```

4. Customize the AI service and model names in the auto_commit.sh script if needed:
    ```bash
    AI_SERVICE="gemini" # options: groq, local, gemini
    GROQ_AI_MODEL_NAME="llama3-70b-8192" # options: llama3-8b-8192, llama3-70b-8192
    GEMINI_AI_MODEL_NAME="gemini-1.5-pro" # options: gemini-1.5-flash, gemini-1.5-pro, gemini-1.0-pro
    LOCAL_AI_MODEL_NAME="phi3:latest" # options: codestral:latest, phi3:latest, llama3:latest
   ```
5. Run the auto_commit.sh script to automatically generate commit messages based on staged changes:
   ```bash
    ./auto_commit.sh
    ```

### Setting Up Local AI Using Ollama

For those interested in using local AI, you can set up Ollama. Visit [Ollama](https://ollama.com/) to get started with
setting up a local Ollama instance. You can also download various models from
the [Ollama Library](https://ollama.com/library). For a UI to manage your Ollama, consider using
the [Open WebUI repository](https://github.com/open-webui/open-webui).

## Usage

Once the setup is complete, you can run the auto_commit.sh script to generate commit messages based on staged changes.
The script will automatically commit the changes with the generated message.

```bash
./auto_commit.sh
```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or additional
features.
   
