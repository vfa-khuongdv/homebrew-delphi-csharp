import { BaseChatModel } from '@langchain/core/language_models/chat_models';
import { HumanMessage, SystemMessage } from '@langchain/core/messages';
import { StringOutputParser } from '@langchain/core/output_parsers';
import { ConfigManager } from '../config/ConfigManager';
import { DelphiParser } from '../parser/DelphiParser';
import { CSharpGenerator } from '../generator/CSharpGenerator';
import { LLMFactory, LLMConfig, LLMProvider } from '../utils/LLMFactory';

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
export class DelphiToCSharpConverter {
  private chatModel: BaseChatModel;
  private delphiParser: DelphiParser;
  private csharpGenerator: CSharpGenerator;
  private outputParser: StringOutputParser;

  constructor(private config: ConfigManager) {
    // Create default LLM configuration
    const defaultProvider: LLMProvider = (config.getConfig().provider as LLMProvider) || 'openai';
    const llmConfig: LLMConfig = {
      provider: defaultProvider,
      model: config.getConfig().defaultModel || 'gpt-4o-mini',
      apiKey: defaultProvider === 'ollama' ? '' : config.getApiKeyForProvider(defaultProvider),
      temperature: 0.1,
      maxTokens: 4000,
      baseURL: this.getBaseURLForProvider(defaultProvider)
    };

    this.chatModel = LLMFactory.createLLM(llmConfig);
    this.delphiParser = new DelphiParser();
    this.csharpGenerator = new CSharpGenerator();
    this.outputParser = new StringOutputParser();
  }

  /**
   * Convert Delphi code to C#
   */
  async convert(delphiCode: string, options: ConversionOptions = {}): Promise<string> {
    try {
      // Parse Delphi code to understand structure
      const parsedStructure = this.delphiParser.parse(delphiCode);
      
      if (options.verbose) {
        console.log('📋 Parsed Delphi structure:', parsedStructure);
      }

      // Create conversion prompt
      const prompt = this.createConversionPrompt(delphiCode, parsedStructure, options);

      // Create messages for LangChain
      const messages = [
        new SystemMessage(this.getSystemPrompt(options)),
        new HumanMessage(prompt)
      ];

      // Update model if specified in options
      if (options.model || options.provider) {
        const provider = options.provider || (this.config.getConfig().provider as LLMProvider) || 'openai';
        const llmConfig: LLMConfig = {
          provider: provider,
          model: options.model || this.config.getConfig().defaultModel || 'gpt-4o-mini',
          apiKey: provider === 'ollama' ? '' : this.config.getApiKeyForProvider(provider),
          temperature: 0.1,
          maxTokens: 4000,
          baseURL: this.getBaseURLForProvider(provider)
        };

        this.chatModel = LLMFactory.createLLM(llmConfig);
      }

      // Call LangChain model
      const response = await this.chatModel.invoke(messages);
      const csharpCode = await this.outputParser.invoke(response);

      if (!csharpCode) {
        throw new Error('No response from LLM');
      }

      // Post-process and format the generated C# code
      const formattedCode = this.csharpGenerator.formatCode(csharpCode);

      if (options.verbose) {
        console.log('✨ Generated C# code length:', formattedCode.length);
      }

      return formattedCode;
    } catch (error) {
      throw new Error(`Conversion failed: ${(error as Error).message}`);
    }
  }

  /**
   * Create the conversion prompt for the LLM
   */
  private createConversionPrompt(
    delphiCode: string, 
    parsedStructure: any, 
    options: ConversionOptions
  ): string {
    const targetFramework = options.targetFramework || '.NET 6.0';
    
    return `Please convert the following Delphi code to C#:

**Target Framework:** ${targetFramework}
**Preserve Comments:** ${options.preserveComments !== false}

**Delphi Code:**
\`\`\`pascal
${delphiCode}
\`\`\`

**Parsed Structure:**
${JSON.stringify(parsedStructure, null, 2)}

**Requirements:**
1. Convert to modern C# following best practices
2. Use appropriate C# naming conventions (PascalCase for classes, camelCase for variables)
3. Handle Delphi-specific constructs (begin/end -> {}, var declarations, etc.)
4. Convert Delphi types to appropriate C# types
5. Preserve the original logic and functionality
6. Add using statements as needed
7. Use proper C# syntax and idioms

Please provide only the converted C# code without explanation.`;
  }

  /**
   * Get the system prompt for the LLM
   */
  private getSystemPrompt(options: ConversionOptions): string {
    return `You are an expert programmer specialized in converting Delphi (Pascal) code to C#. 

You have deep knowledge of:
- Delphi/Pascal syntax, types, and patterns
- C# language features and best practices
- Common migration patterns and pitfalls
- .NET framework capabilities

Your task is to convert Delphi code to equivalent, idiomatic C# code while:
- Maintaining the original functionality
- Following C# naming conventions and style guidelines
- Using appropriate .NET types and patterns
- Ensuring the code compiles and runs correctly
- Preserving comments and documentation when requested

Always provide clean, well-formatted C# code that follows modern C# practices.`;
  }

  /**
   * Get base URL for a specific provider
   */
  private getBaseURLForProvider(provider: LLMProvider): string | undefined {
    switch (provider) {
      case 'ollama':
        return this.config.getConfig().ollamaBaseURL || 'http://localhost:11434';
      case 'azure':
        return this.config.getConfig().baseURL;
      default:
        return undefined;
    }
  }
}
