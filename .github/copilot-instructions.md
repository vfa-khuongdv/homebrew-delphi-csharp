# Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is a TypeScript CLI application that converts Delphi (Pascal) code to C# using Large Language Models (LLM).

## Key Components
- **CLI Interface**: Built with Commander.js for command-line interactions
- **File Processing**: Parse and process Delphi source files (.pas, .dpr, etc.)
- **LLM Integration**: Use OpenAI API to perform intelligent code conversion
- **Output Management**: Generate clean C# code with proper formatting

## Development Guidelines
- Use TypeScript with strict type checking
- Follow modular architecture with separate concerns
- Implement proper error handling and logging
- Use async/await patterns for API calls
- Maintain clean code separation between parsing, conversion, and output

## Code Style
- Use camelCase for variables and functions
- Use PascalCase for classes and interfaces
- Prefer composition over inheritance
- Write comprehensive JSDoc comments for public APIs
