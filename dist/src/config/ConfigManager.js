"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ConfigManager = void 0;
const promises_1 = __importDefault(require("fs/promises"));
const path_1 = __importDefault(require("path"));
const os_1 = __importDefault(require("os"));
/**
 * Manages application configuration
 */
class ConfigManager {
    constructor() {
        this.config = {};
        this.configPath = path_1.default.join(os_1.default.homedir(), '.delphi-to-csharp-config.json');
        this.loadConfig();
    }
    static getInstance() {
        if (!ConfigManager.instance) {
            ConfigManager.instance = new ConfigManager();
        }
        return ConfigManager.instance;
    }
    /**
     * Load configuration from file
     */
    async loadConfig() {
        try {
            const configData = await promises_1.default.readFile(this.configPath, 'utf-8');
            this.config = JSON.parse(configData);
        }
        catch (error) {
            // Config file doesn't exist or is invalid, use defaults
            this.config = this.getDefaultConfig();
        }
    }
    /**
     * Get current configuration
     */
    getConfig() {
        return { ...this.config };
    }
    /**
     * Set configuration
     */
    async setConfig(newConfig) {
        this.config = { ...this.config, ...newConfig };
        await this.saveConfig();
    }
    /**
     * Save configuration to file
     */
    async saveConfig() {
        try {
            await promises_1.default.writeFile(this.configPath, JSON.stringify(this.config, null, 2));
        }
        catch (error) {
            throw new Error(`Failed to save configuration: ${error.message}`);
        }
    }
    /**
     * Get default configuration
     */
    getDefaultConfig() {
        return {
            provider: 'openai',
            defaultModel: 'gpt-4o-mini',
            preserveComments: true,
            targetFramework: '.NET 6.0'
        };
    }
    /**
     * Validate configuration
     */
    validateConfig() {
        if (!this.config.openaiApiKey) {
            throw new Error('OpenAI API key is required. Run "setup" command first.');
        }
        return true;
    }
    /**
     * Get OpenAI API key from environment or config
     */
    getOpenAIApiKey() {
        return process.env.OPENAI_API_KEY || this.config.openaiApiKey || '';
    }
    /**
     * Get API key for specific provider
     */
    getApiKeyForProvider(provider) {
        const envKey = this.getEnvKeyForProvider(provider);
        const configKey = this.getConfigKeyForProvider(provider);
        return process.env[envKey] || this.config[configKey] || '';
    }
    /**
     * Get environment variable name for provider
     */
    getEnvKeyForProvider(provider) {
        switch (provider) {
            case 'openai':
            case 'azure':
                return 'OPENAI_API_KEY';
            case 'anthropic':
                return 'ANTHROPIC_API_KEY';
            case 'google':
                return 'GOOGLE_API_KEY';
            default:
                return 'API_KEY';
        }
    }
    /**
     * Get config property name for provider
     */
    getConfigKeyForProvider(provider) {
        switch (provider) {
            case 'openai':
            case 'azure':
                return 'openaiApiKey';
            case 'anthropic':
                return 'anthropicApiKey';
            case 'google':
                return 'googleApiKey';
            default:
                return 'openaiApiKey';
        }
    }
}
exports.ConfigManager = ConfigManager;
//# sourceMappingURL=ConfigManager.js.map