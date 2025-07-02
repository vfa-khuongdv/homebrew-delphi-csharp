/**
 * Utility class for file operations
 */
export declare class FileProcessor {
    /**
     * Read file content
     */
    readFile(filePath: string): Promise<string>;
    /**
     * Write content to file
     */
    writeFile(filePath: string, content: string): Promise<void>;
    /**
     * Find files matching a pattern
     */
    findFiles(directory: string, pattern: string): Promise<string[]>;
    /**
     * Get output file path for converted file (preserves directory structure)
     */
    getOutputPath(inputPath: string, outputDir: string, newExtension: string, preserveStructure?: boolean, baseDir?: string): string;
    /**
     * Get output file path preserving the directory structure relative to a base directory
     */
    getOutputPathWithStructure(inputPath: string, outputDir: string, newExtension: string, baseDir: string): string;
    /**
     * Check if file exists
     */
    fileExists(filePath: string): Promise<boolean>;
    /**
     * Get file size
     */
    getFileSize(filePath: string): Promise<number>;
    /**
     * Create backup of existing file
     */
    createBackup(filePath: string): Promise<string>;
    /**
     * Validate Delphi file extension
     */
    isDelphiFile(filePath: string): boolean;
    /**
     * Get relative path from base directory
     */
    getRelativePath(filePath: string, baseDir: string): string;
    /**
     * Ensure directory exists
     */
    ensureDirectory(dirPath: string): Promise<void>;
    /**
     * Get file extension without dot
     */
    getFileExtension(filePath: string): string;
    /**
     * Read directory contents
     */
    readDirectory(dirPath: string): Promise<string[]>;
    /**
     * Check if path is a directory
     */
    isDirectory(path: string): Promise<boolean>;
    /**
     * Get file modification time
     */
    getModificationTime(filePath: string): Promise<Date>;
}
//# sourceMappingURL=FileProcessor.d.ts.map