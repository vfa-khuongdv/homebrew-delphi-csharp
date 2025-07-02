import { BaseChatModel } from '@langchain/core/language_models/chat_models';
export type LLMProvider = 'openai' | 'anthropic' | 'google' | 'azure';
export interface LLMConfig {
    provider: LLMProvider;
    model: string;
    apiKey: string;
    temperature?: number;
    maxTokens?: number;
    baseURL?: string;
}
/**
 * Factory for creating different LLM instances
 */
export declare class LLMFactory {
    /**
     * Create an LLM instance based on the provided configuration
     */
    static createLLM(config: LLMConfig): BaseChatModel;
    /**
     * Get available models for a provider
     */
    static getAvailableModels(provider: LLMProvider): string[];
    /**
     * Validate LLM configuration
     */
    static validateConfig(config: LLMConfig): boolean;
    /**
     * Get default configuration for a provider
     */
    static getDefaultConfig(provider: LLMProvider): Partial<LLMConfig>;
    /**
     * Extract Azure instance name from base URL
     */
    private static extractInstanceName;
}
//# sourceMappingURL=LLMFactory.d.ts.map