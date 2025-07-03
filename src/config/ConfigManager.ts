import fs from 'fs/promises';
import path from 'path';
import os from 'os';
import { LLMProvider } from '../utils/LLMFactory';

export interface AppConfig {
  provider: LLMProvider;
  openaiApiKey: string;
  anthropicApiKey?: string;
  googleApiKey?: string;
  ollamaBaseURL?: string;
  vfaApiKey?: string;
  vfaBaseURL?: string; // For VFA office
  groqApiKey?: string;
  defaultModel: string;
  outputDirectory?: string;
  preserveComments?: boolean;
  targetFramework?: string;
  baseURL?: string;
}

/**
 * Manages application configuration
 */
export class ConfigManager {
  private static instance: ConfigManager;
  private config: Partial<AppConfig> = {};
  private configPath: string;

  private constructor() {
    this.configPath = path.join(os.homedir(), '.delphi-to-csharp-config.json');
    // Load config synchronously during initialization
    this.loadConfigSync();
  }

  static getInstance(): ConfigManager {
    if (!ConfigManager.instance) {
      ConfigManager.instance = new ConfigManager();
    }
    return ConfigManager.instance;
  }

  /**
   * Load configuration from file
   */
  private async loadConfig(): Promise<void> {
    try {
      const configData = await fs.readFile(this.configPath, 'utf-8');
      this.config = JSON.parse(configData);
    } catch (error) {
      // Config file doesn't exist or is invalid, use defaults
      this.config = this.getDefaultConfig();
    }
  }

  /**
   * Load configuration from file synchronously
   */
  private loadConfigSync(): void {
    try {
      const fs = require('fs');
      const configData = fs.readFileSync(this.configPath, 'utf-8');
      this.config = JSON.parse(configData);
    } catch (error) {
      // Config file doesn't exist or is invalid, use defaults
      this.config = this.getDefaultConfig();
    }
  }

  /**
   * Get current configuration
   */
  getConfig(): Partial<AppConfig> {
    return { ...this.config };
  }

  /**
   * Set configuration
   */
  async setConfig(newConfig: Partial<AppConfig>): Promise<void> {
    this.config = { ...this.config, ...newConfig };
    await this.saveConfig();
  }

  /**
   * Save configuration to file
   */
  private async saveConfig(): Promise<void> {
    try {
      await fs.writeFile(this.configPath, JSON.stringify(this.config, null, 2));
    } catch (error) {
      throw new Error(`Failed to save configuration: ${(error as Error).message}`);
    }
  }

  /**
   * Get default configuration
   */
  private getDefaultConfig(): Partial<AppConfig> {
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
  validateConfig(): boolean {
    // For Ollama, API key is not required
    if (this.config.provider === 'ollama') {
      return true;
    }
    
    if (!this.config.openaiApiKey && this.config.provider === 'openai') {
      throw new Error('OpenAI API key is required. Run "setup" command first.');
    }
    return true;
  }

  /**
   * Get OpenAI API key from environment or config
   */
  getOpenAIApiKey(): string {
    return process.env.OPENAI_API_KEY || this.config.openaiApiKey || '';
  }

  /**
   * Get API key for specific provider
   */
  getApiKeyForProvider(provider: LLMProvider): string {
    // For Ollama, API key is not required
    if (provider === 'ollama') {
      return '';
    }
    
    const envKey = this.getEnvKeyForProvider(provider);
    const configKey = this.getConfigKeyForProvider(provider);
    
    // Priority: environment variable > config file
    const envValue = process.env[envKey];
    if (envValue) {
      return envValue;
    }
    
    const configValue = this.config[configKey] as string;
    if (configValue) {
      return configValue;
    }
    
    // Default to empty string for optional providers
    if (provider === 'groq' && !envValue && !configValue) {
      console.warn(`No API key found for ${provider}, but continuing...`);
      return '';
    }
    
    throw new Error(`API key not found for provider: ${provider}. Please set ${envKey} environment variable or run setup command.`);
  }

  /**
   * Get environment variable name for provider
   */
  private getEnvKeyForProvider(provider: LLMProvider): string {
    switch (provider) {
      case 'openai':
        return 'OPENAI_API_KEY';
      case 'anthropic':
        return 'ANTHROPIC_API_KEY';
      case 'google':
        return 'GOOGLE_API_KEY';
      case 'ollama':
        return 'OLLAMA_BASE_URL';
      case 'groq':
        return 'GROQ_API_KEY';
      case 'vfa':
        return 'VFA_API_KEY';
      default:
        return 'API_KEY';
    }
  }

  /**
   * Get config property name for provider
   */
  private getConfigKeyForProvider(provider: LLMProvider): keyof AppConfig {
    switch (provider) {
      case 'openai':
        return 'openaiApiKey';
      case 'anthropic':
        return 'anthropicApiKey';
      case 'google':
        return 'googleApiKey';
      case 'ollama':
        return 'ollamaBaseURL';
      case 'groq':
        return 'groqApiKey';
      case 'vfa':
        return 'vfaApiKey';
      default:
        return 'openaiApiKey';
    }
  }
}
