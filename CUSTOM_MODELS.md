# Custom Model Support

The Delphi to C# converter supports custom model names for all LLM providers, giving you the flexibility to use any model beyond the predefined options.

## How Custom Models Work

When setting up the converter or using it via CLI, you can:

1. **Select from predefined models** - Choose from a curated list of popular models for each provider
2. **Enter custom model names** - Type any model name that your provider supports

## Provider-Specific Custom Model Support

### OpenAI
- **Custom models**: Any GPT model, including newer versions or custom fine-tuned models
- **Examples**: 
  - `gpt-4-turbo-preview`
  - `gpt-3.5-turbo-16k`
  - `gpt-4-0314` (specific version)
  - Your fine-tuned models (e.g., `ft:gpt-3.5-turbo:company:model:id`)

### Anthropic Claude
- **Custom models**: Any Claude model variant available to your API key
- **Examples**:
  - `claude-3-opus-20240229`
  - `claude-3-sonnet-20240229`
  - `claude-3-haiku-20240307`
  - Newer model versions as they become available

### Google Gemini
- **Custom models**: Any Gemini model supported by the Google AI API
- **Examples**:
  - `gemini-1.5-pro`
  - `gemini-1.0-pro-vision`
  - `gemini-1.0-pro-001` (specific version)
  - `models/gemini-pro` (full model path)

### Groq
- **Custom models**: Any model available on the Groq platform
- **Examples**:
  - `mixtral-8x7b-32768`
  - `llama2-70b-4096`
  - `gemma-7b-it`
  - Any newly added models on Groq

### Ollama (Local)
- **Custom models**: Any model you've pulled or imported
- **Examples**:
  - `codellama:13b`
  - `qwen2.5-coder:32b`
  - `deepseek-coder-v2:16b`
  - `starcoder2:15b`
  - Custom imported models
  - Fine-tuned local models

### VFA Office
- **Custom models**: Any model supported by your VFA instance
- **Examples**:
  - Standard OpenAI models
  - Custom deployed models
  - Organization-specific models

## Usage Examples

### During Setup
```bash
# Run interactive setup
delphi-csharp setup

# For non-Ollama providers:
# 1. Select your provider
# 2. Choose "Custom model (type your own)" from the model list
# 3. Enter your custom model name

# For Ollama:
# 1. Select "Ollama (Local)"
# 2. Directly enter any model name (no predefined list)
```

### Command Line Usage
```bash
# Use custom OpenAI model
delphi-csharp convert MyFile.pas -p openai -m gpt-4-turbo-preview

# Use custom Anthropic model
delphi-csharp convert MyFile.pas -p anthropic -m claude-3-opus-20240229

# Use custom Ollama model
delphi-csharp convert MyFile.pas -p ollama -m qwen2.5-coder:32b

# Use custom Groq model
delphi-csharp convert MyFile.pas -p groq -m mixtral-8x7b-32768
```

### Batch Processing with Custom Models
```bash
# Convert entire directory with custom model
delphi-csharp batch ./delphi-source -p ollama -m codellama:13b

# Preserve structure with custom model
delphi-csharp batch ./src --preserve-structure -p openai -m gpt-4-turbo-preview
```

## Model Validation

The converter performs basic validation:

1. **Required fields**: Provider and model name are required
2. **Warning system**: If a custom model is not in the predefined list, you'll see a warning but the conversion will proceed
3. **API validation**: The actual model availability is validated by the provider's API during conversion

## Best Practices

### Choosing Custom Models

1. **For code conversion tasks**:
   - Prefer models trained on code (e.g., `codellama`, `qwen2.5-coder`)
   - Use larger models for complex conversions
   - Use smaller models for simple conversions to save costs/time

2. **For cost optimization**:
   - Test with smaller models first
   - Use larger models only when needed
   - Consider local models (Ollama) for no API costs

3. **For quality**:
   - Newer model versions often perform better
   - Code-specific models usually outperform general models
   - Test different models with your specific Delphi code

### Model Naming Conventions

- **OpenAI**: Use exact model names from OpenAI documentation
- **Anthropic**: Include full model name with date (e.g., `claude-3-opus-20240229`)
- **Ollama**: Include size variants (e.g., `:7b`, `:13b`, `:32b`)
- **Google**: Can use short names (`gemini-pro`) or full paths (`models/gemini-pro`)

## Troubleshooting

### Common Issues

1. **Model not found**:
   - Verify the model name spelling
   - Check if the model is available to your API key/subscription
   - For Ollama: ensure you've pulled the model (`ollama pull model-name`)

2. **Authentication errors**:
   - Verify your API key is correct and has access to the model
   - Some custom models may require special permissions

3. **Rate limiting**:
   - Some custom or newer models may have different rate limits
   - Consider using smaller models or adding delays between requests

### Getting Help

- Check provider documentation for available models
- Use `ollama list` to see available local models
- Test model access with simple API calls before conversion
- Check the converter logs for specific error messages
