# Delphi to C# Converter

A powerful TypeScript CLI application that converts Delphi (Pascal) code to C# using Large Language Models (LLM) through OpenAI API.

## ✨ Features

- 🔄 **Smart Conversion**: Uses AI to understand Delphi code structure and convert to idiomatic C#
- 📁 **Batch Processing**: Convert multiple files or entire directories
- �️ **Preserve Structure**: Maintains directory structure in output (./models/Person.pas → ./output/models/Person.cs)
- 🔗 **Import Handling**: Intelligently converts Delphi units and imports to C# namespaces
- �🎯 **Accurate Mapping**: Proper type conversion and naming convention transformation
- 🛠 **CLI Interface**: Easy-to-use command-line interface
- ⚙️ **Multi-LLM Support**: OpenAI, Anthropic Claude, Google Gemini, Azure OpenAI
- 🔧 **Configurable**: Support for different LLM models and conversion options

## 🚀 Quick Start

1. Clone and install:
```bash
git clone git@github.com:vfa-khuongdv/homebrew-delphi-csharp.git
cd homebrew-delphi-csharp
npm install
npm run build
```

2. Set up your OpenAI API key in `.env`:
```bash
OPENAI_API_KEY=your_api_key_here
```

3. Convert a Delphi file with preserved directory structure:
```bash
# Basic conversion (output goes to output/ directory)
node dist/cli.js convert examples/Calculator.pas

# Convert with preserved directory structure
node dist/cli.js convert examples/models/Person.pas --preserve-structure --base-dir examples
# Output: output/models/Person.cs

# Convert entire project maintaining structure
node dist/cli.js batch examples --preserve-structure
```

4. List converted files:
```bash
node dist/cli.js list
```

## 📋 Usage Examples

### Convert Single File
```bash
# Basic conversion (file goes to output/ directory)
node dist/cli.js convert examples/Calculator.pas

# Convert with preserved directory structure
node dist/cli.js convert examples/models/Person.pas --preserve-structure --base-dir examples
# Result: output/models/Person.cs

# Custom output path
node dist/cli.js convert examples/Calculator.pas -o my-output/Calculator.cs
```

### Convert Files with Complex Imports
The converter intelligently handles Delphi units that import from multiple directories:

**Delphi file structure:**
```
examples/
├── Employee.pas               # imports utils.StringHelper, models.Person
├── models/
│   └── Person.pas
└── utils/
    └── StringHelper.pas
```

**Convert with structure preservation:**
```bash
node dist/cli.js convert examples/Employee.pas --preserve-structure --base-dir examples
```

**Result:**
```
output/
├── Employee.cs                # with proper C# using statements
├── models/
│   └── Person.cs
└── utils/
    └── StringHelper.cs
```

### Convert with Different Providers
```bash
# Using OpenAI GPT-4
node dist/cli.js convert examples/Calculator.pas -p openai -m gpt-4o

# Using Anthropic Claude
node dist/cli.js convert examples/Calculator.pas -p anthropic -m claude-3-5-sonnet-20241022

# Using Google Gemini  
node dist/cli.js convert examples/Calculator.pas -p google -m gemini-1.5-pro

# Using Azure OpenAI
node dist/cli.js convert examples/Calculator.pas -p azure -m gpt-4
```

### Batch Convert Directory
```bash
# Convert all files maintaining directory structure (default behavior)
node dist/cli.js batch ./delphi-source

# Convert to custom output directory
node dist/cli.js batch ./delphi-source --output ./converted-csharp

# Disable structure preservation (flat output)
node dist/cli.js batch ./examples/003-SearchBTDevices --no-preserve-structure --output ./003-SearchBTDevices
```

### List Converted Files
```bash
node dist/cli.js list
```

### Interactive Setup
```bash
node dist/cli.js setup
```

## 📁 How to Convert All Source Code in a Folder

The CLI supports batch conversion of entire directories containing Delphi source files. This is perfect for converting large codebases or multiple projects at once.

### Basic Batch Conversion
```bash
# Convert all Delphi files in a directory
node dist/cli.js batch ./your-delphi-folder

# Example: Convert all files in a project directory
node dist/cli.js batch ./MyDelphiProject
```

### Advanced Batch Options
```bash
# Use specific LLM provider and model
node dist/cli.js batch ./delphi-source -p anthropic -m claude-3-5-sonnet-20241022

# Specify custom output directory
node dist/cli.js batch ./delphi-source -o ./converted-csharp

# Use custom file pattern (only .pas files)
node dist/cli.js batch ./delphi-source --pattern "**/*.pas"

# Combine multiple options
node dist/cli.js batch ./MyProject -p openai -m gpt-4o -o ./output/MyProject
```

### Supported File Types
The batch converter automatically finds and converts:
- `.pas` files (Pascal units)
- `.dpr` files (Delphi projects)  
- `.dpk` files (Delphi packages)

### Example Workflow
```bash
# 1. Set up your API key (one-time setup)
node dist/cli.js setup

# 2. Convert entire project folder
node dist/cli.js batch ./MyDelphiProject -p openai -m gpt-4o

# 3. Check converted files
node dist/cli.js list

# 4. Files are now in output/ directory with same structure
```

### Batch Conversion Features
- ✅ **Recursive Processing**: Finds all Delphi files in subdirectories
- ✅ **Preserves Structure**: Maintains folder hierarchy in output (enabled by default)
- ✅ **Import Resolution**: Converts Delphi unit references to C# using statements
- ✅ **Progress Tracking**: Shows conversion progress for each file
- ✅ **Error Handling**: Continues processing if individual files fail
- ✅ **Flexible Output**: Choose any output directory
- ✅ **File Filtering**: Use patterns to include/exclude specific files

## 🔧 Commands

### `convert` - Convert single file
```bash
convert <input> [options]
```
- `<input>` - Path to Delphi file (.pas, .dpr, .dpk)
- `-o, --output <path>` - Output C# file path (default: output/ directory)
- `-s, --preserve-structure` - Preserve directory structure in output
- `-b, --base-dir <dir>` - Base directory for preserving structure (default: input file directory)
- `-m, --model <model>` - LLM model (default: gpt-4o-mini)
- `-p, --provider <provider>` - LLM provider (openai, anthropic, google, azure)
- `-v, --verbose` - Verbose output

**Examples:**
```bash
# Basic conversion
node dist/cli.js convert ./examples/tests/Calculator.pas

# Preserve directory structure
node dist/cli.js convert ./examples/tests/models/Person.pas --preserve-structure --base-dir ./examples
# Result: output/tests/models/Person.cs

# Custom output with specific model
node dist/cli.js convert ./examples/tests/models/Calculator.pas -o ./converted/models/Calculator.cs -m gpt-4o
```

### `batch` - Convert multiple files
```bash
batch <directory> [options]
```
Convert all Delphi source files in a directory and its subdirectories.

**Arguments:**
- `<directory>` - Directory containing Delphi files to convert

**Options:**
- `-o, --output <dir>` - Output directory (default: `output`)
- `-s, --preserve-structure` - Preserve directory structure (default: `true`)
- `-m, --model <model>` - LLM model to use for conversion
- `-p, --provider <provider>` - LLM provider (openai, anthropic, google, azure)
- `--pattern <pattern>` - File pattern to match (default: `**/*.{pas,dpr,dpk,inc,dfm,fmx}`)

**Examples:**
```bash
# Convert all files in project folder (preserves structure by default)
node dist/cli.js batch ./examples/tests

# Use specific provider and model
node dist/cli.js batch ./examples/tests -p anthropic -m claude-3-5-sonnet-20241022

# Custom output directory with structure preservation
node dist/cli.js batch ./examples/tests -o ./modernized --preserve-structure

node dist/cli.js batch ./examples/003-SearchBTDevices --preserve-structure --output ./output/003-SearchBTDevices
node dist/cli.js batch ./examples/009-ImageListHighDPI --preserve-structure --output ./output/009-ImageListHighDPI


# Convert tests examples with structure preservation
node dist/cli.js batch ./examples/tests --preserve-structure

# Flat output (no structure preservation)
node dist/cli.js batch ./examples/tests -o ./converted --no-preserve-structure

# Only convert .pas files
node dist/cli.js batch ./examples/tests --pattern "**/*.pas"
```

**Directory Structure Example:**
```bash
# Input structure:
MyProject/
├── Main.pas
├── Core/
│   ├── Engine.pas
│   └── Utils.pas
└── Models/
    └── User.pas

# After: node dist/cli.js batch MyProject
output/
├── Main.cs
├── Core/
│   ├── Engine.cs
│   └── Utils.cs
└── Models/
    └── User.cs
```

### `list` - List converted files
```bash
list [options]
```
- `-d, --directory <dir>` - Directory to list (default: output)

### `setup` - Configure LLM providers
```bash
setup
```
Interactive setup for API keys and model selection across all supported providers.

## 📊 Conversion Examples

### Input (Delphi with Imports)
```pascal
unit Employee;

interface

uses
  SysUtils,
  utils.StringHelper,  // Import from utils directory
  models.Person;       // Import from models directory

type
  TEmployee = class(TPerson)
  private
    FEmployeeId: String;
    FSalary: Double;
  public
    constructor Create(const AName: String; const AAge: Integer; 
                      const AEmployeeId: String; const ASalary: Double);
    function GetEmployeeInfo: String;
    property EmployeeId: String read FEmployeeId write FEmployeeId;
    property Salary: Double read FSalary write FSalary;
  end;

implementation

constructor TEmployee.Create(const AName: String; const AAge: Integer; 
                            const AEmployeeId: String; const ASalary: Double);
begin
  inherited Create(AName, AAge);
  FEmployeeId := AEmployeeId;
  FSalary := ASalary;
  // Using imported StringHelper
  if TStringHelper.IsEmpty(FEmployeeId) then
    raise Exception.Create('Employee ID cannot be empty');
end;

function TEmployee.GetEmployeeInfo: String;
begin
  Result := Format('Employee %s - Salary: $%.2f', [FEmployeeId, FSalary]);
end;
```

### Output (C# with Proper Namespaces)
```csharp
using System;
using Utils; // Converted from utils.StringHelper
using Models; // Converted from models.Person

namespace Employee
{
    public class Employee : Person
    {
        private string employeeId;
        private double salary;

        public Employee(string name, int age, string employeeId, double salary)
            : base(name, age)
        {
            this.employeeId = employeeId;
            this.salary = salary;
            
            // Using imported StringHelper
            if (StringHelper.IsEmpty(employeeId))
                throw new Exception("Employee ID cannot be empty");
        }

        public string GetEmployeeInfo()
        {
            return string.Format("Employee {0} - Salary: ${1:F2}", employeeId, salary);
        }

        public string EmployeeId
        {
            get => employeeId;
            set => employeeId = value;
        }

        public double Salary
        {
            get => salary;
            set => salary = value;
        }
    }
}
```

### Simple Class Example
#### Input (Delphi)
```pascal
unit Calculator;

type
  TCalculator = class
  private
    FResult: Double;
  public
    function Add(A, B: Double): Double;
    property Result: Double read FResult write FResult;
  end;

function TCalculator.Add(A, B: Double): Double;
begin
  FResult := A + B;
  Result := FResult;
end;
```

#### Output (C#)
```csharp
using System;

namespace Calculator
{
    public class Calculator
    {
        private double _result;

        public double Add(double a, double b)
        {
            _result = a + b;
            return _result;
        }

        public double Result
        {
            get { return _result; }
            set { _result = value; }
        }
    }
}
```

## 🗂 Project Structure

```
delphi-to-csharp-converter/
├── cli.ts                              # Main CLI application
├── src/
│   ├── converter/
│   │   └── DelphiToCSharpConverter.ts  # Core conversion logic
│   ├── parser/
│   │   └── DelphiParser.ts             # Delphi code parser
│   ├── generator/
│   │   └── CSharpGenerator.ts          # C# code formatter
│   ├── config/
│   │   └── ConfigManager.ts            # Configuration management
│   └── utils/
│       ├── FileProcessor.ts            # File operations & structure preservation
│       └── LLMFactory.ts               # Multi-provider LLM factory
├── examples/
│   └── tests/                           # Example Delphi files
│       ├── Calculator.pas               # Simple calculator class
│       ├── Employee.pas                 # Complex class with imports
│       ├── CompanyManager.pas           # Multiple imports example
│       ├── models/
│       │   └── Person.pas               # Base person class
│       └── utils/
│           └── StringHelper.pas         # String utility functions
└── output/
    └── tests/                           # Converted C# files (preserves structure)
        ├── Calculator.cs
        ├── Employee.cs
        ├── CompanyManager.cs
        ├── models/
        │   └── Person.cs
        └── utils/
            └── StringHelper.cs
```

## 🔧 Development

### Build
```bash
npm run build
```

### Development Mode
```bash
npm run dev <command>
```

### Watch Mode
```bash
npm run watch
```

## 🤖 Supported LLM Providers

### OpenAI
- **Models**: gpt-4, gpt-4-turbo, gpt-4o, gpt-4o-mini, gpt-3.5-turbo
- **Setup**: Requires OpenAI API key
- **Usage**: `node cli.js convert input.pas -p openai -m gpt-4o`

### Anthropic Claude
- **Models**: claude-3-5-sonnet-20241022, claude-3-5-haiku-20241022, claude-3-opus-20240229
- **Setup**: Requires Anthropic API key
- **Usage**: `node cli.js convert input.pas -p anthropic -m claude-3-5-sonnet-20241022`

### Google Gemini
- **Models**: gemini-1.5-pro, gemini-1.5-flash, gemini-1.0-pro
- **Setup**: Requires Google AI API key
- **Usage**: `node cli.js convert input.pas -p google -m gemini-1.5-flash`

### Azure OpenAI
- **Models**: gpt-4, gpt-4-turbo, gpt-35-turbo
- **Setup**: Requires Azure OpenAI API key and base URL
- **Usage**: `node cli.js convert input.pas -p azure -m gpt-4`

## ⚙️ Configuration

### Environment Variables
```bash
# API Keys for different providers
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here  
GOOGLE_API_KEY=your_google_api_key_here

# Default settings
DEFAULT_MODEL=gpt-4o-mini
TARGET_FRAMEWORK=.NET 6.0
OUTPUT_DIRECTORY=./output
```

### Config File
The application stores configuration in `~/.delphi-to-csharp-config.json`

### Interactive Setup
Run `node dist/cli.js setup` for guided configuration of any provider.

## 🧪 Testing

The project includes example files for testing:
- `examples/tests/Calculator.pas` - Basic class example
- `examples/tests/Person.pas` - Properties and methods example

## 📝 Supported Delphi Features

- ✅ Unit structure and uses clauses
- ✅ Cross-directory imports (utils.StringHelper → Utils namespace)
- ✅ Type definitions (records, enums, aliases)
- ✅ Constants and variables
- ✅ Functions and procedures
- ✅ Classes with inheritance
- ✅ Properties and methods
- ✅ Exception handling
- ✅ String formatting and manipulation
- ✅ Basic syntax constructs

## 🗺 Type Mapping

| Delphi Type | C# Type |
|-------------|---------|
| Integer | int |
| String | string |
| Boolean | bool |
| Double | double |
| TDateTime | DateTime |
| Array | Array/List<T> |

## 🔗 Import/Namespace Mapping

| Delphi Uses | C# Using |
|-------------|----------|
| `utils.StringHelper` | `using Utils;` |
| `models.Person` | `using Models;` |
| `System.SysUtils` | `using System;` |
| `Classes` | `using System.Collections.Generic;` |

**Directory Structure Preservation:**
```
Delphi Project:                C# Output:
src/                          output/
├── Main.pas         →        ├── Main.cs
├── utils/           →        ├── utils/
│   └── Helper.pas   →        │   └── Helper.cs
└── models/          →        └── models/
    └── User.pas     →            └── User.cs
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

1. **Missing API Key**: Run `node cli.js setup` or set `OPENAI_API_KEY` environment variable
2. **Build Errors**: Run `npm run clean && npm install && npm run build`
3. **File Permission Issues**: Ensure write permissions to output directory

### Support

For issues and questions, please create an issue on the GitHub repository.
