"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DelphiToCSharpConverter = void 0;
const messages_1 = require("@langchain/core/messages");
const output_parsers_1 = require("@langchain/core/output_parsers");
const DelphiParser_1 = require("../parser/DelphiParser");
const CSharpGenerator_1 = require("../generator/CSharpGenerator");
const LLMFactory_1 = require("../utils/LLMFactory");
/**
 * Main converter class that orchestrates the conversion from Delphi to C#
 */
class DelphiToCSharpConverter {
    constructor(config) {
        this.config = config;
        // Create default LLM configuration
        const defaultProvider = config.getConfig().provider || 'openai';
        const llmConfig = {
            provider: defaultProvider,
            model: config.getConfig().defaultModel || 'gpt-4o-mini',
            apiKey: config.getApiKeyForProvider(defaultProvider),
            temperature: 0.1,
            maxTokens: 4000
        };
        this.chatModel = LLMFactory_1.LLMFactory.createLLM(llmConfig);
        this.delphiParser = new DelphiParser_1.DelphiParser();
        this.csharpGenerator = new CSharpGenerator_1.CSharpGenerator();
        this.outputParser = new output_parsers_1.StringOutputParser();
    }
    /**
     * Convert Delphi code to C#
     */
    async convert(delphiCode, options = {}) {
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
                new messages_1.SystemMessage(this.getSystemPrompt(options)),
                new messages_1.HumanMessage(prompt)
            ];
            // Update model if specified in options
            if (options.model || options.provider) {
                const provider = options.provider || this.config.getConfig().provider || 'openai';
                const llmConfig = {
                    provider: provider,
                    model: options.model || this.config.getConfig().defaultModel || 'gpt-4o-mini',
                    apiKey: this.config.getApiKeyForProvider(provider),
                    temperature: 0.1,
                    maxTokens: 4000
                };
                this.chatModel = LLMFactory_1.LLMFactory.createLLM(llmConfig);
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
        }
        catch (error) {
            throw new Error(`Conversion failed: ${error.message}`);
        }
    }
    /**
     * Create the conversion prompt for the LLM
     */
    createConversionPrompt(delphiCode, parsedStructure, options) {
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
    getSystemPrompt(options) {
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
}
exports.DelphiToCSharpConverter = DelphiToCSharpConverter;
//# sourceMappingURL=DelphiToCSharpConverter.js.map