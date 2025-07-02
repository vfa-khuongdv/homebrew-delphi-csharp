"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileProcessor = void 0;
const promises_1 = __importDefault(require("fs/promises"));
const path_1 = __importDefault(require("path"));
const glob_1 = require("glob");
/**
 * Utility class for file operations
 */
class FileProcessor {
    /**
     * Read file content
     */
    async readFile(filePath) {
        try {
            const content = await promises_1.default.readFile(filePath, 'utf-8');
            return content;
        }
        catch (error) {
            throw new Error(`Failed to read file ${filePath}: ${error.message}`);
        }
    }
    /**
     * Write content to file
     */
    async writeFile(filePath, content) {
        try {
            // Ensure directory exists
            const dir = path_1.default.dirname(filePath);
            await promises_1.default.mkdir(dir, { recursive: true });
            await promises_1.default.writeFile(filePath, content, 'utf-8');
        }
        catch (error) {
            throw new Error(`Failed to write file ${filePath}: ${error.message}`);
        }
    }
    /**
     * Find files matching a pattern
     */
    async findFiles(directory, pattern) {
        try {
            const searchPattern = path_1.default.join(directory, pattern);
            const files = await (0, glob_1.glob)(searchPattern);
            return files;
        }
        catch (error) {
            throw new Error(`Failed to find files in ${directory}: ${error.message}`);
        }
    }
    /**
     * Get output file path for converted file (preserves directory structure)
     */
    getOutputPath(inputPath, outputDir, newExtension, preserveStructure = false, baseDir) {
        if (!preserveStructure) {
            // Original behavior - just filename
            const fileName = path_1.default.basename(inputPath, path_1.default.extname(inputPath));
            return path_1.default.join(outputDir, fileName + newExtension);
        }
        // Preserve directory structure
        const fileName = path_1.default.basename(inputPath, path_1.default.extname(inputPath));
        if (baseDir) {
            // Get relative path from base directory
            const relativePath = path_1.default.relative(baseDir, path_1.default.dirname(inputPath));
            return path_1.default.join(outputDir, relativePath, fileName + newExtension);
        }
        else {
            // Use the same directory structure as input
            const inputDir = path_1.default.dirname(inputPath);
            return path_1.default.join(outputDir, inputDir, fileName + newExtension);
        }
    }
    /**
     * Get output file path preserving the directory structure relative to a base directory
     */
    getOutputPathWithStructure(inputPath, outputDir, newExtension, baseDir) {
        const fileName = path_1.default.basename(inputPath, path_1.default.extname(inputPath));
        const relativePath = path_1.default.relative(baseDir, path_1.default.dirname(inputPath));
        // Handle case where input is directly in base directory
        const outputPath = relativePath
            ? path_1.default.join(outputDir, relativePath, fileName + newExtension)
            : path_1.default.join(outputDir, fileName + newExtension);
        return outputPath;
    }
    /**
     * Check if file exists
     */
    async fileExists(filePath) {
        try {
            await promises_1.default.access(filePath);
            return true;
        }
        catch {
            return false;
        }
    }
    /**
     * Get file size
     */
    async getFileSize(filePath) {
        try {
            const stats = await promises_1.default.stat(filePath);
            return stats.size;
        }
        catch (error) {
            throw new Error(`Failed to get file size for ${filePath}: ${error.message}`);
        }
    }
    /**
     * Create backup of existing file
     */
    async createBackup(filePath) {
        const backupPath = `${filePath}.backup`;
        try {
            await promises_1.default.copyFile(filePath, backupPath);
            return backupPath;
        }
        catch (error) {
            throw new Error(`Failed to create backup for ${filePath}: ${error.message}`);
        }
    }
    /**
     * Validate Delphi file extension
     */
    isDelphiFile(filePath) {
        const ext = path_1.default.extname(filePath).toLowerCase();
        return ['.pas', '.dpr', '.dpk', '.inc'].includes(ext);
    }
    /**
     * Get relative path from base directory
     */
    getRelativePath(filePath, baseDir) {
        return path_1.default.relative(baseDir, filePath);
    }
    /**
     * Ensure directory exists
     */
    async ensureDirectory(dirPath) {
        try {
            await promises_1.default.mkdir(dirPath, { recursive: true });
        }
        catch (error) {
            throw new Error(`Failed to create directory ${dirPath}: ${error.message}`);
        }
    }
    /**
     * Get file extension without dot
     */
    getFileExtension(filePath) {
        return path_1.default.extname(filePath).slice(1).toLowerCase();
    }
    /**
     * Read directory contents
     */
    async readDirectory(dirPath) {
        try {
            const items = await promises_1.default.readdir(dirPath);
            return items;
        }
        catch (error) {
            throw new Error(`Failed to read directory ${dirPath}: ${error.message}`);
        }
    }
    /**
     * Check if path is a directory
     */
    async isDirectory(path) {
        try {
            const stats = await promises_1.default.stat(path);
            return stats.isDirectory();
        }
        catch {
            return false;
        }
    }
    /**
     * Get file modification time
     */
    async getModificationTime(filePath) {
        try {
            const stats = await promises_1.default.stat(filePath);
            return stats.mtime;
        }
        catch (error) {
            throw new Error(`Failed to get modification time for ${filePath}: ${error.message}`);
        }
    }
}
exports.FileProcessor = FileProcessor;
//# sourceMappingURL=FileProcessor.js.map