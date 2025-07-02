"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LLMFactory = void 0;
const openai_1 = require("@langchain/openai");
const google_genai_1 = require("@langchain/google-genai");
const anthropic_1 = require("@langchain/anthropic");
/**
 * Factory for creating different LLM instances
 */
class LLMFactory {
    /**
     * Create an LLM instance based on the provided configuration
     */
    static createLLM(config) {
        switch (config.provider) {
            case 'openai':
                return new openai_1.ChatOpenAI({
                    openAIApiKey: config.apiKey,
                    modelName: config.model,
                    temperature: config.temperature || 0.1,
                    maxTokens: config.maxTokens || 4000,
                    configuration: config.baseURL ? {
                        baseURL: config.baseURL
                    } : undefined
                });
            case 'azure':
                return new openai_1.ChatOpenAI({
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
                return new google_genai_1.ChatGoogleGenerativeAI({
                    apiKey: config.apiKey,
                    model: config.model,
                    temperature: config.temperature || 0.1,
                    maxOutputTokens: config.maxTokens || 4000,
                });
            case 'anthropic':
                return new anthropic_1.ChatAnthropic({
                    anthropicApiKey: config.apiKey,
                    modelName: config.model,
                    temperature: config.temperature || 0.1,
                    maxTokens: config.maxTokens || 4000,
                });
            default:
                throw new Error(`Unsupported LLM provider: ${config.provider}`);
        }
    }
    /**
     * Get available models for a provider
     */
    static getAvailableModels(provider) {
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
            default:
                return [];
        }
    }
    /**
     * Validate LLM configuration
     */
    static validateConfig(config) {
        if (!config.provider) {
            throw new Error('LLM provider is required');
        }
        if (!config.model) {
            throw new Error('LLM model is required');
        }
        if (!config.apiKey) {
            throw new Error('API key is required');
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
    static getDefaultConfig(provider) {
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
            default:
                return {};
        }
    }
    /**
     * Extract Azure instance name from base URL
     */
    static extractInstanceName(baseURL) {
        if (!baseURL)
            return '';
        const match = baseURL.match(/https:\/\/([^.]+)\.openai\.azure\.com/);
        return match ? match[1] : '';
    }
}
exports.LLMFactory = LLMFactory;
//# sourceMappingURL=LLMFactory.js.map