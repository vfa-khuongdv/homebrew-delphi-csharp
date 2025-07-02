#!/usr/bin/env node
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const commander_1 = require("commander");
const chalk_1 = __importDefault(require("chalk"));
const dotenv = __importStar(require("dotenv"));
const DelphiToCSharpConverter_1 = require("./src/converter/DelphiToCSharpConverter");
const FileProcessor_1 = require("./src/utils/FileProcessor");
const ConfigManager_1 = require("./src/config/ConfigManager");
const LLMFactory_1 = require("./src/utils/LLMFactory");
const path_1 = __importDefault(require("path"));
// Load environment variables
dotenv.config();
const program = new commander_1.Command();
program
    .name('delphi-to-csharp')
    .description('Convert Delphi code to C# using AI')
    .version('1.0.0');
program
    .command('convert')
    .description('Convert a Delphi file to C#')
    .argument('<input>', 'Input Delphi file path')
    .option('-o, --output <path>', 'Output C# file path')
    .option('-m, --model <model>', 'LLM model to use', 'gpt-4o-mini')
    .option('-p, --provider <provider>', 'LLM provider (openai, azure, anthropic, google)', 'openai')
    .option('-s, --preserve-structure', 'Preserve directory structure in output')
    .option('-b, --base-dir <dir>', 'Base directory for preserving structure (default: input file directory)')
    .option('-v, --verbose', 'Verbose output')
    .action(async (input, options) => {
    try {
        console.log(chalk_1.default.blue('🔄 Starting Delphi to C# conversion...'));
        const config = ConfigManager_1.ConfigManager.getInstance();
        const fileProcessor = new FileProcessor_1.FileProcessor();
        const converter = new DelphiToCSharpConverter_1.DelphiToCSharpConverter(config);
        // Read input file
        const delphiCode = await fileProcessor.readFile(input);
        console.log(chalk_1.default.green(`✅ Read Delphi file: ${input}`));
        // Convert to C#
        const csharpCode = await converter.convert(delphiCode, {
            model: options.model,
            provider: options.provider,
            verbose: options.verbose
        });
        // Determine output path
        let outputPath;
        if (options.output) {
            outputPath = options.output;
        }
        else if (options.preserveStructure) {
            const baseDir = options.baseDir || path_1.default.dirname(input);
            outputPath = fileProcessor.getOutputPathWithStructure(input, 'output', '.cs', baseDir);
        }
        else {
            outputPath = `output/${path_1.default.basename(input).replace(/\.(pas|dpr|dpk)$/i, '.cs')}`;
        }
        // Write output
        await fileProcessor.writeFile(outputPath, csharpCode);
        console.log(chalk_1.default.green(`✅ Conversion completed! Output: ${outputPath}`));
    }
    catch (error) {
        console.error(chalk_1.default.red('❌ Error:'), error.message);
        process.exit(1);
    }
});
program
    .command('batch')
    .description('Convert multiple Delphi files in a directory')
    .argument('<directory>', 'Directory containing Delphi files')
    .option('-o, --output <dir>', 'Output directory for C# files', 'output')
    .option('-m, --model <model>', 'LLM model to use', 'gpt-4o-mini')
    .option('-p, --provider <provider>', 'LLM provider (openai, azure, anthropic, google)', 'openai')
    .option('-s, --preserve-structure', 'Preserve directory structure in output (default: true)', true)
    .option('--pattern <pattern>', 'File pattern to match', '**/*.{pas,dpr,dpk}')
    .action(async (directory, options) => {
    try {
        console.log(chalk_1.default.blue('🔄 Starting batch conversion...'));
        const config = ConfigManager_1.ConfigManager.getInstance();
        const fileProcessor = new FileProcessor_1.FileProcessor();
        const converter = new DelphiToCSharpConverter_1.DelphiToCSharpConverter(config);
        const files = await fileProcessor.findFiles(directory, options.pattern);
        console.log(chalk_1.default.blue(`Found ${files.length} Delphi files`));
        if (options.preserveStructure) {
            console.log(chalk_1.default.blue('📁 Preserving directory structure in output'));
        }
        for (const file of files) {
            try {
                const delphiCode = await fileProcessor.readFile(file);
                const csharpCode = await converter.convert(delphiCode, {
                    model: options.model,
                    provider: options.provider
                });
                // Generate output path with preserved structure
                const outputPath = options.preserveStructure
                    ? fileProcessor.getOutputPathWithStructure(file, options.output, '.cs', directory)
                    : fileProcessor.getOutputPath(file, options.output, '.cs');
                await fileProcessor.writeFile(outputPath, csharpCode);
                console.log(chalk_1.default.green(`✅ Converted: ${file} -> ${outputPath}`));
            }
            catch (error) {
                console.error(chalk_1.default.red(`❌ Failed to convert ${file}:`), error.message);
            }
        }
        console.log(chalk_1.default.green('✅ Batch conversion completed!'));
    }
    catch (error) {
        console.error(chalk_1.default.red('❌ Error:'), error.message);
        process.exit(1);
    }
});
program
    .command('setup')
    .description('Setup LLM provider configuration')
    .action(async () => {
    const inquirer = (await Promise.resolve().then(() => __importStar(require('inquirer')))).default;
    const answers = await inquirer.prompt([
        {
            type: 'list',
            name: 'provider',
            message: 'Select LLM provider:',
            choices: [
                { name: 'OpenAI', value: 'openai' },
                { name: 'Azure OpenAI', value: 'azure' },
                { name: 'Anthropic Claude', value: 'anthropic' },
                { name: 'Google Gemini', value: 'google' }
            ],
            default: 'openai'
        },
        {
            type: 'list',
            name: 'model',
            message: 'Select default model:',
            choices: (answers) => LLMFactory_1.LLMFactory.getAvailableModels(answers.provider),
            default: 'gpt-4o-mini'
        },
        {
            type: 'password',
            name: 'apiKey',
            message: (answers) => {
                const provider = answers.provider;
                switch (provider) {
                    case 'openai':
                    case 'azure':
                        return 'Enter your OpenAI API key:';
                    case 'anthropic':
                        return 'Enter your Anthropic API key:';
                    case 'google':
                        return 'Enter your Google AI API key:';
                    default:
                        return 'Enter your API key:';
                }
            },
            mask: '*'
        },
        {
            type: 'input',
            name: 'baseURL',
            message: 'Enter base URL (optional, for custom endpoints):',
            when: (answers) => answers.provider === 'azure'
        }
    ]);
    const config = ConfigManager_1.ConfigManager.getInstance();
    // Prepare config object based on provider
    const configUpdate = {
        provider: answers.provider,
        defaultModel: answers.model,
        baseURL: answers.baseURL
    };
    // Set the appropriate API key field
    switch (answers.provider) {
        case 'openai':
        case 'azure':
            configUpdate.openaiApiKey = answers.apiKey;
            break;
        case 'anthropic':
            configUpdate.anthropicApiKey = answers.apiKey;
            break;
        case 'google':
            configUpdate.googleApiKey = answers.apiKey;
            break;
    }
    await config.setConfig(configUpdate);
    console.log(chalk_1.default.green('✅ Configuration saved!'));
    console.log(chalk_1.default.blue(`Provider: ${answers.provider}`));
    console.log(chalk_1.default.blue(`Model: ${answers.model}`));
});
program
    .command('list')
    .description('List converted C# files in output directory')
    .option('-d, --directory <dir>', 'Directory to list files from', 'output')
    .action(async (options) => {
    try {
        const fileProcessor = new FileProcessor_1.FileProcessor();
        const outputDir = options.directory;
        if (!(await fileProcessor.isDirectory(outputDir))) {
            console.log(chalk_1.default.yellow(`📁 Directory ${outputDir} does not exist`));
            return;
        }
        const files = await fileProcessor.findFiles(outputDir, '*.cs');
        if (files.length === 0) {
            console.log(chalk_1.default.yellow(`📄 No C# files found in ${outputDir}`));
            return;
        }
        console.log(chalk_1.default.blue(`📋 Found ${files.length} C# files in ${outputDir}:`));
        files.forEach((file, index) => {
            const relativePath = path_1.default.relative(process.cwd(), file);
            console.log(chalk_1.default.green(`  ${index + 1}. ${relativePath}`));
        });
    }
    catch (error) {
        console.error(chalk_1.default.red('❌ Error:'), error.message);
    }
});
program.parse();
//# sourceMappingURL=cli.js.map