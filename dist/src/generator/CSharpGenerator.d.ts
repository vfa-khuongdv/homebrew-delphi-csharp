/**
 * Generator for C# code formatting and post-processing
 */
export declare class CSharpGenerator {
    /**
     * Format and clean up generated C# code
     */
    formatCode(code: string): string;
    /**
     * Remove markdown code block markers
     */
    private removeMarkdownBlocks;
    /**
     * Fix code indentation
     */
    private fixIndentation;
    /**
     * Add common using statements if not present
     */
    private addUsingStatements;
    /**
     * Ensure code is wrapped in a namespace if it contains classes
     */
    private ensureNamespace;
    /**
     * Indent a block of code
     */
    private indentBlock;
    /**
     * Clean up extra whitespace
     */
    private cleanupWhitespace;
    /**
     * Convert Delphi types to C# types
     */
    static convertType(delphiType: string): string;
    /**
     * Convert Delphi identifier to C# naming convention
     */
    static convertIdentifier(identifier: string, context: 'class' | 'method' | 'property' | 'field' | 'variable' | 'constant'): string;
    /**
     * Convert to PascalCase
     */
    private static toPascalCase;
    /**
     * Convert to camelCase
     */
    private static toCamelCase;
}
//# sourceMappingURL=CSharpGenerator.d.ts.map