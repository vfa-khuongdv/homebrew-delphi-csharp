#!/usr/bin/env node

import { Command } from 'commander';
import chalk from 'chalk';
import * as dotenv from 'dotenv';
import { DelphiToCSharpConverter } from './src/converter/DelphiToCSharpConverter';
import { FileProcessor } from './src/utils/FileProcessor';
import { ConfigManager } from './src/config/ConfigManager';
import { LLMFactory, LLMProvider } from './src/utils/LLMFactory';
import path from 'path';

// Load environment variables
dotenv.config();

const program = new Command();

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
      console.log(chalk.blue('🔄 Starting Delphi to C# conversion...'));
      
      const config = ConfigManager.getInstance();
      const fileProcessor = new FileProcessor();
      const converter = new DelphiToCSharpConverter(config);

      // Read input file
      const delphiCode = await fileProcessor.readFile(input);
      console.log(chalk.green(`✅ Read Delphi file: ${input}`));

      // Convert to C#
      const csharpCode = await converter.convert(delphiCode, {
        model: options.model,
        provider: options.provider as LLMProvider,
        verbose: options.verbose
      });

      // Determine output path
      let outputPath: string;
      if (options.output) {
        outputPath = options.output;
      } else if (options.preserveStructure) {
        const baseDir = options.baseDir || path.dirname(input);
        outputPath = fileProcessor.getOutputPathWithStructure(input, 'output', '.cs', baseDir);
      } else {
        outputPath = `output/${path.basename(input).replace(/\.(pas|dpr|dpk)$/i, '.cs')}`;
      }

      // Write output
      await fileProcessor.writeFile(outputPath, csharpCode);

      console.log(chalk.green(`✅ Conversion completed! Output: ${outputPath}`));
    } catch (error) {
      console.error(chalk.red('❌ Error:'), (error as Error).message);
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
      console.log(chalk.blue('🔄 Starting batch conversion...'));
      
      const config = ConfigManager.getInstance();
      const fileProcessor = new FileProcessor();
      const converter = new DelphiToCSharpConverter(config);

      const files = await fileProcessor.findFiles(directory, options.pattern);
      console.log(chalk.blue(`Found ${files.length} Delphi files`));

      if (options.preserveStructure) {
        console.log(chalk.blue('📁 Preserving directory structure in output'));
      }

      for (const file of files) {
        try {
          const delphiCode = await fileProcessor.readFile(file);
          const csharpCode = await converter.convert(delphiCode, {
            model: options.model,
            provider: options.provider as LLMProvider
          });

          // Generate output path with preserved structure
          const outputPath = options.preserveStructure
            ? fileProcessor.getOutputPathWithStructure(file, options.output, '.cs', directory)
            : fileProcessor.getOutputPath(file, options.output, '.cs');
          
          await fileProcessor.writeFile(outputPath, csharpCode);

          console.log(chalk.green(`✅ Converted: ${file} -> ${outputPath}`));
        } catch (error) {
          console.error(chalk.red(`❌ Failed to convert ${file}:`), (error as Error).message);
        }
      }

      console.log(chalk.green('✅ Batch conversion completed!'));
    } catch (error) {
      console.error(chalk.red('❌ Error:'), (error as Error).message);
      process.exit(1);
    }
  });

program
  .command('setup')
  .description('Setup LLM provider configuration')
  .action(async () => {
    const inquirer = (await import('inquirer')).default;
    
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
        choices: (answers) => LLMFactory.getAvailableModels(answers.provider as LLMProvider),
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

    const config = ConfigManager.getInstance();
    
    // Prepare config object based on provider
    const configUpdate: any = {
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

    console.log(chalk.green('✅ Configuration saved!'));
    console.log(chalk.blue(`Provider: ${answers.provider}`));
    console.log(chalk.blue(`Model: ${answers.model}`));
  });

program
  .command('list')
  .description('List converted C# files in output directory')
  .option('-d, --directory <dir>', 'Directory to list files from', 'output')
  .action(async (options) => {
    try {
      const fileProcessor = new FileProcessor();
      const outputDir = options.directory;
      
      if (!(await fileProcessor.isDirectory(outputDir))) {
        console.log(chalk.yellow(`📁 Directory ${outputDir} does not exist`));
        return;
      }

      const files = await fileProcessor.findFiles(outputDir, '*.cs');
      
      if (files.length === 0) {
        console.log(chalk.yellow(`📄 No C# files found in ${outputDir}`));
        return;
      }

      console.log(chalk.blue(`📋 Found ${files.length} C# files in ${outputDir}:`));
      files.forEach((file, index) => {
        const relativePath = path.relative(process.cwd(), file);
        console.log(chalk.green(`  ${index + 1}. ${relativePath}`));
      });
    } catch (error) {
      console.error(chalk.red('❌ Error:'), (error as Error).message);
    }
  });

program.parse();
