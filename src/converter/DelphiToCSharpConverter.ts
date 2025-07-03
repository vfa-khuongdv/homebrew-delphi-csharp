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
      apiKey: config.getApiKeyForProvider(defaultProvider),
      temperature: 0.1,
      maxTokens: 16384, // Increased to handle larger Delphi files
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
  async convert(delphiCode: string, options: ConversionOptions = {}, filePath?: string): Promise<string> {
    try {
      // Parse Delphi code to understand structure
      const parsedStructure = this.delphiParser.parse(delphiCode);
      
      if (options.verbose) {
        console.log('📋 Parsed Delphi structure:', parsedStructure);
      }

      // Create conversion prompt
      const prompt = this.createConversionPrompt(delphiCode, parsedStructure, options, filePath);

      // Create messages for LangChain
      const messages = [
        new SystemMessage(this.getSystemPrompt(options)),
        new HumanMessage(prompt)
      ];

      // Determine provider and model, prioritizing options over config
      const provider = options.provider || this.config.getConfig().provider || 'openai';
      const model = options.model || this.config.getConfig().defaultModel || 'gpt-4o-mini';

      const llmConfig: LLMConfig = {
        provider: provider,
        model: model,
        apiKey: this.config.getApiKeyForProvider(provider),
        temperature: 0.1,
        maxTokens: 16384, // Note: Increased to handle larger Delphi files
        baseURL: this.getBaseURLForProvider(provider)
      };
      
      console.log(`✨ LLM Configuration: Using model '${llmConfig.model}' from provider '${llmConfig.provider}' with base URL '${llmConfig.baseURL}' and Max Tokens: ${llmConfig.maxTokens}`);

      // Create a new model instance with the correct configuration for this conversion
      this.chatModel = LLMFactory.createLLM(llmConfig);

      // Call LangChain model
      console.log('✨ LLM invoking');
      const response = await this.chatModel.invoke(messages);
      console.log('✨ LLM response received');
      
      const csharpCode = await this.outputParser.invoke(response);

      if (!csharpCode) {
        throw new Error('No response from LLM');
      }

      console.log('✨ Generated C# code length:', csharpCode.length);

      // Post-process and format the generated C# code
      const formattedCode = this.csharpGenerator.formatCode(csharpCode);

      if (options.verbose) {
        console.log('✨ Formatted C# code length:', formattedCode.length);
      }

      return formattedCode;
    } catch (error) {
      console.error(`Conversion failed for ${filePath}:`, error);
      throw new Error(`Conversion failed: ${(error as Error).message}`);
    }
  }

  /**
   * Create the conversion prompt for the LLM
   */
  private createConversionPrompt(
    delphiCode: string, 
    parsedStructure: any, 
    options: ConversionOptions,
    filePath?: string
  ): string {
    const targetFramework = options.targetFramework || '.NET 6.0';
    const namespace = this.generateNamespaceFromPath(filePath);
    
    return `Please convert the following Delphi code to C#:

**Target Framework:** ${targetFramework}
**Preserve Comments:** ${options.preserveComments !== false}
**Namespace:** ${namespace}
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
8. Use the suggested namespace: ${namespace} (or a similar meaningful namespace based on the project structure)
9. Avoid generic namespaces like "YourNamespace", "ConvertedCode", "Namespace1", etc.

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
- Add TODO if the C# code similarity is below 100% to mark potential areas needing revision. when using // TODO, provide a brief comment explaining the reason for the TODO and similarity percent. 
// Example: 
- // TODO: This code is not 100% similar to Delphi, similarity is 95%.
- // Suggest: Suggestion for the coder the way to fix or improve the code, if applicable.

Always provide clean, well-formatted C# code that follows modern C# practices.`;
  }

  /**
   * Generate a meaningful namespace based on the file path
   */
  private generateNamespaceFromPath(filePath?: string): string {
    if (!filePath) {
      return 'DefaultNamespace';
    }

    // Extract path components and create namespace
    const parts = filePath.split(/[\/\\]/).filter(part => 
      part && 
      !part.includes('.') && 
      part !== 'examples' && 
      part !== 'src' && 
      part !== 'output' &&
      part !== 'tools' &&
      part !== 'Desktop' &&
      part !== 'Users'
    );

    if (parts.length === 0) {
      return 'DefaultNamespace';
    }

    // Convert to PascalCase and join with dots
    const namespaceParts = parts.map(part => {
      // Handle special cases like numbers and hyphens
      return part
        .replace(/^\d+\-?/, '') // Remove leading numbers and hyphens (e.g., "009-" -> "")
        .split(/[-_]/) // Split on hyphens and underscores
        .map(segment => segment.charAt(0).toUpperCase() + segment.slice(1).toLowerCase())
        .join('');
    }).filter(part => part.length > 0); // Remove empty parts

    // Return namespace without prefix, just the folder structure
    return namespaceParts.length > 0 
      ? namespaceParts.join('.')
      : 'DefaultNamespace';
  }

  /**
   * Get base URL for a specific provider
   */
  private getBaseURLForProvider(provider: LLMProvider): string | undefined {
    switch (provider) {
      case 'ollama':
        return this.config.getConfig().ollamaBaseURL || 'http://localhost:11434';
      case 'vfa':
        return this.config.getConfig().vfaBaseURL || 'https://llm.vitalify.asia/v1';
      default:
        return undefined;
    }
  }
}
