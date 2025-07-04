import { ChatOpenAI } from '@langchain/openai';
import { ChatGoogleGenerativeAI } from '@langchain/google-genai';
import { ChatAnthropic } from '@langchain/anthropic';
import { ChatOllama } from '@langchain/ollama';
import { ChatGroq } from '@langchain/groq';
import { BaseChatModel } from '@langchain/core/language_models/chat_models';
import modelsData from '../config/models.json';

export type LLMProvider = 'openai' | 'anthropic' | 'google' | 'azure' | 'ollama' | 'groq' | 'vfa'; 

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
          maxTokens: config.maxTokens,
          configuration: config.baseURL ? {
            baseURL: config.baseURL
          } : undefined
        });

      case 'vfa':
        return new ChatOpenAI({
          openAIApiKey: config.apiKey,
          modelName: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens ,
          timeout: 30 * 60 * 1000, // 30 minutes
          maxRetries: 0, // No retries for OpenAI
          configuration: {
            baseURL: config.baseURL || 'https://llm.vitalify.asia/v1', // Default VFA base URL
          }
        });

      case 'google':
        return new ChatGoogleGenerativeAI({
          apiKey: config.apiKey,
          model: config.model,
          temperature: config.temperature || 0.1,
          maxOutputTokens: config.maxTokens,
        });
      
      case 'anthropic':
        return new ChatAnthropic({
          anthropicApiKey: config.apiKey,
          modelName: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens,
        });
      
      case 'ollama':
        return new ChatOllama({
          baseUrl: config.baseURL || 'http://localhost:11434',
          model: config.model,
          temperature: config.temperature || 0.1,
          numCtx: config.maxTokens,
        });
      case 'groq':
        return new ChatGroq({
          apiKey: config.apiKey,
          model: config.model,
          temperature: config.temperature || 0.1,
          maxTokens: config.maxTokens,
          baseUrl: config.baseURL ? config.baseURL : undefined,
        });
      default:
        throw new Error(`Unsupported LLM provider: ${config.provider}`);
    }
  }

  /**
   * Get available models for a provider
   */
  static getAvailableModels(provider: LLMProvider): string[] {
    if (provider in modelsData) {
      return modelsData[provider as keyof typeof modelsData] || [];
    }
    return [];
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
    if (!['ollama', 'groq'].includes(config.provider) && !config.apiKey) {
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
          model: 'qwen2.5-coder:0.5b',
          temperature: 0.1,
          maxTokens: 4000,
          baseURL: 'http://localhost:11434' // Default Ollama URL
          // No API key needed for Ollama
        };

      case 'vfa':
        return {
          provider: 'vfa',
          model: 'gpt-4o-mini',
          temperature: 0.1,
          maxTokens: 4000
        };

      case 'groq':
        return {
          provider: 'groq',
          model: 'llama3-70b-8192',
          temperature: 0.1,
          maxTokens: 4000
        };
      
      default:
        return {};
    }
  }
}
