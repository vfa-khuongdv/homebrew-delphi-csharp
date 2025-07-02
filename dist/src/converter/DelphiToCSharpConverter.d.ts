import { ConfigManager } from '../config/ConfigManager';
import { LLMProvider } from '../utils/LLMFactory';
export interface ConversionOptions {
    model?: string;
    verbose?: boolean;
    preserveComments?: boolean;
    targetFramework?: string;
    provider?: LLMProvider;
}
export interface ConversionResult {
    csharpCode: string;
    warnings: string[];
    suggestions: string[];
}
/**
 * Main converter class that orchestrates the conversion from Delphi to C#
 */
export declare class DelphiToCSharpConverter {
    private config;
    private chatModel;
    private delphiParser;
    private csharpGenerator;
    private outputParser;
    constructor(config: ConfigManager);
    /**
     * Convert Delphi code to C#
     */
    convert(delphiCode: string, options?: ConversionOptions): Promise<string>;
    /**
     * Create the conversion prompt for the LLM
     */
    private createConversionPrompt;
    /**
     * Get the system prompt for the LLM
     */
    private getSystemPrompt;
}
//# sourceMappingURL=DelphiToCSharpConverter.d.ts.map