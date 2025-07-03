import { ChatOpenAI } from '@langchain/openai';
import { ChatGoogleGenerativeAI } from '@langchain/google-genai';
import { ChatAnthropic } from '@langchain/anthropic';
import { ChatOllama } from '@langchain/ollama';
import { BaseChatModel } from '@langchain/core/language_models/chat_models';

export type LLMProvider = 'openai' | 'anthropic' | 'google' | 'azure' | 'ollama';

export interface LLMConfig {
  provider: LLMProvider;
  model: string;
  apiKey?: string; // Made optional for Ollama
  temperature?: number;
  maxTokens?: number;
  baseURL?: string; // For custom endpoints
}

/**
 * Factory for creating different LLM instances
 */
export class LLMFactory {
  
  /**
   * Create an LLM instance based on the provided configuration
   */
  static createLLM(config: LLMConfig): BaseChatModel {
    switch (config.provider) {
      case 'openai':
        return new ChatOpenAI({
          openAIApiKey: config.apiKey,
          modelName: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens || 4000,
          configuration: config.baseURL ? {
            baseURL: config.baseURL
          } : undefined
        });
      
      case 'azure':
        return new ChatOpenAI({
          openAIApiKey: config.apiKey,
          modelName: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens || 4000,
          configuration: {
            baseURL: config.baseURL,
            defaultHeaders: {
              'api-key': config.apiKey
            }
          }
        });
      
      case 'google':
        return new ChatGoogleGenerativeAI({
          apiKey: config.apiKey,
          model: config.model,
          temperature: config.temperature || 0.1,
          maxOutputTokens: config.maxTokens || 4000,
        });
      
      case 'anthropic':
        return new ChatAnthropic({
          anthropicApiKey: config.apiKey,
          modelName: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens || 4000,
        });
      
      case 'ollama':
        return new ChatOllama({
          baseUrl: config.baseURL || 'http://localhost:11434',
          model: config.model,
          temperature: config.temperature || 0.1,
          numCtx: config.maxTokens || 4000,
        });
      
      default:
        throw new Error(`Unsupported LLM provider: ${config.provider}`);
    }
  }

  /**
   * Get available models for a provider
   */
  static getAvailableModels(provider: LLMProvider): string[] {
    switch (provider) {
      case 'openai':
        return [
          'gpt-4',
          'gpt-4-turbo',
          'gpt-4o',
          'gpt-4o-mini',
          'gpt-3.5-turbo'
        ];
      
      case 'azure':
        return [
          'gpt-4',
          'gpt-4-turbo',
          'gpt-35-turbo'
        ];
      
      case 'anthropic':
        return [
          'claude-3-5-sonnet-20241022',
          'claude-3-5-haiku-20241022',
          'claude-3-opus-20240229',
          'claude-3-sonnet-20240229',
          'claude-3-haiku-20240307'
        ];
      
      case 'google':
        return [
          'gemini-2.5-pro',
          'gemini-2.5-flash',
          'gemini-2.0-pro',
          'gemini-2.0-flash',
          'gemini-1.0-pro',
          'gemini-1.0-pro-vision'
        ];
      
      case 'ollama':
        return [
          'llama3.2',
          'llama3.1',
          'llama3.1:70b',
          'llama3.1:405b',
          'codellama',
          'codellama:13b',
          'codellama:34b',
          'deepseek-coder-v2',
          'qwen2.5-coder',
          'qwen2.5-coder:14b',
          'mistral',
          'mixtral',
          'phi3',
          'gemma2'
        ];
      
      default:
        return [];
    }
  }

  /**
   * Validate LLM configuration
   */
  static validateConfig(config: LLMConfig): boolean {
    if (!config.provider) {
      throw new Error('LLM provider is required');
    }

    if (!config.model) {
      throw new Error('LLM model is required');
    }

    // API key is not required for Ollama (local)
    if (config.provider !== 'ollama' && !config.apiKey) {
      throw new Error('API key is required for remote providers');
    }

    const availableModels = this.getAvailableModels(config.provider);
    if (availableModels.length > 0 && !availableModels.includes(config.model)) {
      console.warn(`Model ${config.model} may not be available for provider ${config.provider}`);
    }

    return true;
  }

  /**
   * Get default configuration for a provider
   */
  static getDefaultConfig(provider: LLMProvider): Partial<LLMConfig> {
    switch (provider) {
      case 'openai':
        return {
          provider: 'openai',
          model: 'gpt-4o-mini',
          temperature: 0.1,
          maxTokens: 4000
        };
      
      case 'azure':
        return {
          provider: 'azure',
          model: 'gpt-4',
          temperature: 0.1,
          maxTokens: 4000
        };
      
      case 'anthropic':
        return {
          provider: 'anthropic',
          model: 'claude-3-5-sonnet-20241022',
          temperature: 0.1,
          maxTokens: 4000
        };
      
      case 'google':
        return {
          provider: 'google',
          model: 'gemini-2.0-flash',
          temperature: 0.1,
          maxTokens: 4000
        };
      
      case 'ollama':
        return {
          provider: 'ollama',
          model: 'llama3.2',
          temperature: 0.1,
          maxTokens: 4000,
          baseURL: 'https://milton-tank-only-owen.trycloudflare.com/v1'
          // No API key needed for Ollama
        };
      
      default:
        return {};
    }
  }

  /**
   * Extract Azure instance name from base URL
   */
  private static extractInstanceName(baseURL?: string): string {
    if (!baseURL) return '';
    
    const match = baseURL.match(/https:\/\/([^.]+)\.openai\.azure\.com/);
    return match ? match[1] : '';
  }
}
