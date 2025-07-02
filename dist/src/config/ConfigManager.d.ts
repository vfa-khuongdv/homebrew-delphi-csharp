import { LLMProvider } from '../utils/LLMFactory';
export interface AppConfig {
    provider: LLMProvider;
    openaiApiKey: string;
    anthropicApiKey?: string;
    googleApiKey?: string;
    defaultModel: string;
    outputDirectory?: string;
    preserveComments?: boolean;
    targetFramework?: string;
    baseURL?: string;
}
/**
 * Manages application configuration
 */
export declare class ConfigManager {
    private static instance;
    private config;
    private configPath;
    private constructor();
    static getInstance(): ConfigManager;
    /**
     * Load configuration from file
     */
    private loadConfig;
    /**
     * Get current configuration
     */
    getConfig(): Partial<AppConfig>;
    /**
     * Set configuration
     */
    setConfig(newConfig: Partial<AppConfig>): Promise<void>;
    /**
     * Save configuration to file
     */
    private saveConfig;
    /**
     * Get default configuration
     */
    private getDefaultConfig;
    /**
     * Validate configuration
     */
    validateConfig(): boolean;
    /**
     * Get OpenAI API key from environment or config
     */
    getOpenAIApiKey(): string;
    /**
     * Get API key for specific provider
     */
    getApiKeyForProvider(provider: LLMProvider): string;
    /**
     * Get environment variable name for provider
     */
    private getEnvKeyForProvider;
    /**
     * Get config property name for provider
     */
    private getConfigKeyForProvider;
}
//# sourceMappingURL=ConfigManager.d.ts.map