# Ollama Support

The Delphi to C# converter now supports Ollama for local LLM processing! This means you can run code conversion entirely offline using local models.

## Prerequisites

1. Install Ollama from [https://ollama.com](https://ollama.com)
2. Pull a coding model (recommended):
   ```bash
   ollama pull llama3.2
   # or for better code conversion:
   ollama pull codellama
   ollama pull qwen2.5-coder
   ```

## Setup

Run the setup command and select Ollama:

```bash
delphi-csharp setup
```

Select:
- Provider: **Ollama (Local)**
- Model: Choose from available models (e.g., `llama3.2`, `codellama`, `qwen2.5-coder`)
- Base URL: Default is `http://localhost:11434` (press Enter)

## Usage

### Convert with Ollama
```bash
# Using default Ollama config
delphi-csharp convert MyDelphiFile.pas

# Specify Ollama provider and model
delphi-csharp convert MyDelphiFile.pas -p ollama -m codellama

# Batch conversion with Ollama
delphi-csharp batch ./delphi-source -p ollama -m qwen2.5-coder
```

## Recommended Models for Code Conversion

1. **qwen2.5-coder** - Excellent for code understanding and conversion
2. **codellama** - Specialized for code tasks
3. **llama3.2** - Good general-purpose model
4. **deepseek-coder-v2** - Another excellent coding model

## Benefits of Ollama

- ✅ **Privacy**: All processing happens locally
- ✅ **No API costs**: Free to use once models are downloaded
- ✅ **Offline operation**: Works without internet connection
- ✅ **Customizable**: Use any Ollama-compatible model
- ✅ **Fast**: Local processing can be faster than API calls

## Custom Ollama Server

If you're running Ollama on a different host/port:

```bash
# During setup, specify custom URL
delphi-csharp setup
# Enter: http://your-server:11434

# Or use environment variable
export OLLAMA_BASE_URL=http://your-server:11434
```

## Troubleshooting

1. **Model not found**: Make sure you've pulled the model with `ollama pull <model-name>`
2. **Connection refused**: Ensure Ollama is running with `ollama serve`
3. **Slow performance**: Try smaller models like `llama3.2` or increase your hardware specs
