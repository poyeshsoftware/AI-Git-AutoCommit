# AI-Git-AutoCommit

Automate your git commit messages using AI services like **Azure OpenAI**, **Groq**, **Local AI**, and **Gemini**. This tool helps you maintain consistent and descriptive commit messages with minimal effort.

## Features

- **Supports Multiple AI Services**: Azure OpenAI, Groq, Local AI (via Ollama), and Gemini.
- **Automated Commit Messages**: Generates commit messages based on staged changes.
- **Easy Integration**: Seamlessly integrates into existing workflows.

## Setup

### Prerequisites

- **Git**
- **Curl**
- **jq**: Command-line JSON processor.
- **Access to at least one AI service**:
    - Azure OpenAI Service
    - Groq
    - Gemini
    - Local AI service (e.g., using Ollama)
- **API Keys and Configuration** for the chosen AI service.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/your-username/AI-Git-AutoCommit.git
   cd AI-Git-AutoCommit
```
2. Install the necessary dependencies:

For Mac OS:

   ```bash
    brew install git curl jq
   ```

For Ubuntu:

   ```bash
    sudo apt-get install git curl jq
   ```

3. **Make the auto_commit.sh script executable**:

   ```bash
    chmod +x auto_commit.sh
    ```
   
4. **Create a .env file** in the root directory of the repository and add your API keys:

For Azure OpenAI:
    ```bash
    AZURE_API_KEY=your-azure-api-key
   AZURE_ENDPOINT=your-azure-endpoint # e.g., https://your-resource-name.openai.azure.com/
   AZURE_DEPLOYMENT_NAME=your-deployment-name
   AZURE_API_VERSION=your-api-version # e.g., 2023-03-15-preview
    ```
For Groq:
    ```bash
    GROQ_API_KEY=your-groq-api-key
    ```
For Gemini:
    ```bash
    GEMINI_API_KEY=your-gemini-api-key
    ```
For Local AI (Ollama):
    ```bash
    LOCAL_API_KEY=your-local-api-key
    LOCAL_API_ENDPOINT=your-local-endpoint # e.g., http://localhost:8000
    LOCAL_MODEL_NAME=your-local-model-name # e.g., codestral:latest
    ```
5. **Configure the AI service and model names** in the auto_commit.sh script if needed:

    ```bash
    AI_SERVICE="azure" # options: azure, groq, local, gemini
    # Set the default AI service
    AI_SERVICE="azure" # options: azure, groq, local, gemini
    
    # Azure OpenAI configuration
    AZURE_AI_MODEL_NAME="gpt-4" # As per your deployment
    
    # Groq AI configuration
    GROQ_AI_MODEL_NAME="llama3-70b-8192" # Options: llama3-8b-8192, llama3-70b-8192
    
    # Gemini AI configuration
    GEMINI_AI_MODEL_NAME="gemini-1.5-pro" # Options: gemini-1.5-flash, gemini-1.5-pro, gemini-1.0-pro
    
    # Local AI configuration
    LOCAL_AI_MODEL_NAME="phi3:latest" # Options: codestral:latest, phi3:latest, llama3:latest
    ```

6. **Run the auto_commit.sh script** to automatically generate commit messages based on staged changes:

    ```bash
     ./auto_commit.sh
    ```
## Features

- Supports multiple AI services: Azure OpenAI, Groq, Local AI (via Ollama), and Gemini
- Automatically generates commit messages based on staged changes
- Easy setup and integration into existing workflows

## Usage

Once the setup is complete, you can run the auto_commit.sh script to generate commit messages based on staged changes.
The script will automatically commit the changes with the generated message.

```bash
./auto_commit.sh
```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or additional
features.
   
