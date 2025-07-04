/**
 * Generator for C# code formatting and post-processing
 */
export class CSharpGenerator {
  
  /**
   * Format and clean up generated C# code
   */
  formatCode(code: string): string {
    let formatted = code;

    // Remove any markdown code block markers
    formatted = this.removeMarkdownBlocks(formatted);

    // Fix indentation
    formatted = this.fixIndentation(formatted);

    // Add proper using statements if missing
    formatted = this.addUsingStatements(formatted);

    // Ensure proper namespace structure
    formatted = this.ensureNamespace(formatted);

    // Add AccessibleName properties for Windows Forms controls
    formatted = this.addAccessibleNameProperties(formatted);

    // Clean up extra whitespace
    formatted = this.cleanupWhitespace(formatted);

    return formatted;
  }

  /**
   * Remove markdown code block markers
   */
  private removeMarkdownBlocks(code: string): string {
    // Remove ```csharp and ``` markers
    return code
      .replace(/```(?:csharp|cs|c#)?\s*\n/gi, '')
      .replace(/```\s*$/g, '')
      .trim();
  }

  /**
   * Fix code indentation
   */
  private fixIndentation(code: string): string {
    const lines = code.split('\n');
    const formatted: string[] = [];
    let indentLevel = 0;
    const indentSize = 4;

    lines.forEach(line => {
      const trimmed = line.trim();
      if (!trimmed) {
        formatted.push('');
        return;
      }

      // Decrease indent for closing braces
      if (trimmed === '}' || trimmed.startsWith('}')) {
        indentLevel = Math.max(0, indentLevel - 1);
      }

      // Add the line with proper indentation
      const indent = ' '.repeat(indentLevel * indentSize);
      formatted.push(indent + trimmed);

      // Increase indent for opening braces
      if (trimmed.endsWith('{')) {
        indentLevel++;
      }

      // Handle special cases for switch statements, etc.
      if (trimmed.includes('case ') || trimmed === 'default:') {
        // These should be indented relative to switch
      }
    });

    return formatted.join('\n');
  }

  /**
   * Add common using statements if not present
   */
  private addUsingStatements(code: string): string {
    const commonUsings = [
      'using System;',
      'using System.Collections.Generic;',
      'using System.Linq;',
      'using System.Text;'
    ];

    // Check if this appears to be a Windows Forms file
    const isWindowsForms = /\b(Button|TextBox|Label|ComboBox|Form|Control)\b/.test(code);
    const winFormsUsings = [
      'using System.ComponentModel;',
      'using System.Data;',
      'using System.Drawing;',
      'using System.Windows.Forms;'
    ];

    // Check if using statements already exist
    const hasUsings = /^\s*using\s+/m.test(code);
    
    if (!hasUsings) {
      // Add basic using statements at the top
      let usingsToAdd = [...commonUsings];
      if (isWindowsForms) {
        usingsToAdd = [...usingsToAdd, ...winFormsUsings];
      }
      const usingsBlock = usingsToAdd.join('\n') + '\n\n';
      return usingsBlock + code;
    } else if (isWindowsForms) {
      // Check if Windows Forms usings are already present
      const missingWinFormsUsings = winFormsUsings.filter(usingStmt => 
        !code.includes(usingStmt.replace('using ', '').replace(';', ''))
      );
      
      if (missingWinFormsUsings.length > 0) {
        // Find the last using statement and add missing ones
        const lines = code.split('\n');
        let lastUsingIndex = -1;
        
        for (let i = 0; i < lines.length; i++) {
          if (lines[i].trim().startsWith('using ')) {
            lastUsingIndex = i;
          }
        }
        
        if (lastUsingIndex >= 0) {
          const beforeUsings = lines.slice(0, lastUsingIndex + 1);
          const afterUsings = lines.slice(lastUsingIndex + 1);
          return [...beforeUsings, ...missingWinFormsUsings, ...afterUsings].join('\n');
        }
      }
    }

    return code;
  }

  /**
   * Ensure code is wrapped in a namespace if it contains classes
   */
  private ensureNamespace(code: string): string {
    // Check if there's already a namespace
    if (/namespace\s+\w+/i.test(code)) {
      return code;
    }

    // Check if there are class definitions
    if (/class\s+\w+/i.test(code)) {
      const lines = code.split('\n');
      const namespaceStart = 'namespace ConvertedCode\n{';
      const namespaceEnd = '}';

      // Find the first non-using line to insert namespace
      let insertIndex = 0;
      for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (line && !line.startsWith('using ') && !line.startsWith('//')) {
          insertIndex = i;
          break;
        }
      }

      // Split into before and after namespace
      const beforeNamespace = lines.slice(0, insertIndex).join('\n');
      const afterNamespace = lines.slice(insertIndex).join('\n');

      // Indent the content inside namespace
      const indentedContent = this.indentBlock(afterNamespace);

      return `${beforeNamespace}\n${namespaceStart}\n${indentedContent}\n${namespaceEnd}`;
    }

    return code;
  }

  /**
   * Indent a block of code
   */
  private indentBlock(code: string, spaces: number = 4): string {
    const indent = ' '.repeat(spaces);
    return code
      .split('\n')
      .map(line => line.trim() ? indent + line : line)
      .join('\n');
  }

  /**
   * Clean up extra whitespace
   */
  private cleanupWhitespace(code: string): string {
    return code
      // Remove multiple consecutive empty lines
      .replace(/\n\s*\n\s*\n/g, '\n\n')
      // Remove trailing whitespace
      .replace(/[ \t]+$/gm, '')
      // Ensure file ends with newline
      .replace(/\s*$/, '\n');
  }

  /**
   * Convert Delphi types to C# types
   */
  static convertType(delphiType: string): string {
    const typeMap: { [key: string]: string } = {
      // Integer types
      'Integer': 'int',
      'Cardinal': 'uint',
      'Int64': 'long',
      'LongInt': 'int',
      'LongWord': 'uint',
      'SmallInt': 'short',
      'ShortInt': 'sbyte',
      'Byte': 'byte',
      'Word': 'ushort',

      // Floating point
      'Single': 'float',
      'Double': 'double',
      'Extended': 'decimal',
      'Real': 'double',

      // String types
      'String': 'string',
      'AnsiString': 'string',
      'WideString': 'string',
      'UnicodeString': 'string',
      'PChar': 'string',
      'PWideChar': 'string',

      // Boolean
      'Boolean': 'bool',
      'ByteBool': 'bool',
      'WordBool': 'bool',
      'LongBool': 'bool',

      // Character
      'Char': 'char',
      'AnsiChar': 'char',
      'WideChar': 'char',

      // Pointer
      'Pointer': 'IntPtr',
      'PInteger': 'int*',

      // Variant
      'Variant': 'object',
      'OleVariant': 'object',

      // Date/Time
      'TDateTime': 'DateTime',
      'TDate': 'DateTime',
      'TTime': 'TimeSpan'
    };

    const normalized = delphiType.trim();
    
    // Handle array types
    if (normalized.toLowerCase().startsWith('array')) {
      return 'Array'; // Could be more sophisticated
    }

    // Handle generic types or complex types
    if (normalized.includes('<') || normalized.includes('(')) {
      return normalized; // Return as-is for complex types
    }

    return typeMap[normalized] || normalized;
  }

  /**
   * Convert Delphi identifier to C# naming convention
   */
  static convertIdentifier(identifier: string, context: 'class' | 'method' | 'property' | 'field' | 'variable' | 'constant'): string {
    switch (context) {
      case 'class':
      case 'method':
      case 'property':
        // PascalCase
        return this.toPascalCase(identifier);
      
      case 'field':
      case 'variable':
        // camelCase
        return this.toCamelCase(identifier);
      
      case 'constant':
        // PascalCase for constants in C#
        return this.toPascalCase(identifier);
      
      default:
        return identifier;
    }
  }

  /**
   * Convert to PascalCase
   */
  private static toPascalCase(str: string): string {
    return str
      .replace(/^[a-z]/, char => char.toUpperCase())
      .replace(/_([a-z])/g, (_, char) => char.toUpperCase());
  }

  /**
   * Convert to camelCase
   */
  private static toCamelCase(str: string): string {
    return str
      .replace(/^[A-Z]/, char => char.toLowerCase())
      .replace(/_([a-z])/g, (_, char) => char.toUpperCase());
  }

  /**
   * Add AccessibleName properties for Windows Forms controls
   */
  private addAccessibleNameProperties(code: string): string {

    const lines = code.split('\n');
    const result: string[] = [];
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      result.push(line);
      
      // Look for control Name assignments with or without 'this.' prefix
      // Patterns: this.button1.Name = "button1"; OR button1.Name = "button1";
      const nameAssignmentMatch = line.match(/^\s*(?:this\.)?(\w+)\.Name\s*=\s*"([^"]+)";?\s*$/);
      
      if (nameAssignmentMatch) {
        const controlName = nameAssignmentMatch[1];
        const nameValue = nameAssignmentMatch[2];
        const indent = line.match(/^(\s*)/)?.[1] || '';
        
        // Check if the next line already has AccessibleName
        const nextLine = i + 1 < lines.length ? lines[i + 1] : '';
        const hasAccessibleName = nextLine.includes(`${controlName}.AccessibleName`);
        
        if (!hasAccessibleName) {
          // Determine if we should use 'this.' prefix based on the original line
          const useThisPrefix = line.includes('this.');
          const thisPrefix = useThisPrefix ? 'this.' : '';
          
          // Add AccessibleName property right after Name property
          result.push(`${indent}${thisPrefix}${controlName}.AccessibleName = "${nameValue}";`);
        }
      }
    }
    
    return result.join('\n');
  }
}
