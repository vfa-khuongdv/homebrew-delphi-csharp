import fs from 'fs/promises';
import path from 'path';
import { glob } from 'glob';

/**
 * Utility class for file operations
 */
export class FileProcessor {

  /**
   * Read file content
   */
  async readFile(filePath: string): Promise<string> {
    try {
      const content = await fs.readFile(filePath, 'utf-8');
      return content;
    } catch (error) {
      throw new Error(`Failed to read file ${filePath}: ${(error as Error).message}`);
    }
  }

  /**
   * Write content to file
   */
  async writeFile(filePath: string, content: string): Promise<void> {
    try {
      // Ensure directory exists
      const dir = path.dirname(filePath);
      await fs.mkdir(dir, { recursive: true });
      
      await fs.writeFile(filePath, content, 'utf-8');
    } catch (error) {
      throw new Error(`Failed to write file ${filePath}: ${(error as Error).message}`);
    }
  }

  /**
   * Find files matching a pattern
   */
  async findFiles(directory: string, pattern: string): Promise<string[]> {
    try {
      const searchPattern = path.join(directory, pattern);
      const files = await glob(searchPattern);
      return files;
    } catch (error) {
      throw new Error(`Failed to find files in ${directory}: ${(error as Error).message}`);
    }
  }

  /**
   * Get output file path for converted file (preserves directory structure)
   */
  getOutputPath(inputPath: string, outputDir: string, newExtension: string, preserveStructure: boolean = false, baseDir?: string): string {
    if (!preserveStructure) {
      // Original behavior - just filename
      const fileName = path.basename(inputPath, path.extname(inputPath));
      return path.join(outputDir, fileName + newExtension);
    }

    // Preserve directory structure
    const fileName = path.basename(inputPath, path.extname(inputPath));
    
    if (baseDir) {
      // Get relative path from base directory
      const relativePath = path.relative(baseDir, path.dirname(inputPath));
      return path.join(outputDir, relativePath, fileName + newExtension);
    } else {
      // Use the same directory structure as input
      const inputDir = path.dirname(inputPath);
      return path.join(outputDir, inputDir, fileName + newExtension);
    }
  }

  /**
   * Get output file path preserving the directory structure relative to a base directory
   */
  getOutputPathWithStructure(inputPath: string, outputDir: string, newExtension: string, baseDir: string): string {
    const fileName = path.basename(inputPath, path.extname(inputPath));
    const relativePath = path.relative(baseDir, path.dirname(inputPath));
    
    // Handle case where input is directly in base directory
    const outputPath = relativePath 
      ? path.join(outputDir, relativePath, fileName + newExtension)
      : path.join(outputDir, fileName + newExtension);
    
    return outputPath;
  }

  /**
   * Check if file exists
   */
  async fileExists(filePath: string): Promise<boolean> {
    try {
      await fs.access(filePath);
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Get file size
   */
  async getFileSize(filePath: string): Promise<number> {
    try {
      const stats = await fs.stat(filePath);
      return stats.size;
    } catch (error) {
      throw new Error(`Failed to get file size for ${filePath}: ${(error as Error).message}`);
    }
  }

  /**
   * Create backup of existing file
   */
  async createBackup(filePath: string): Promise<string> {
    const backupPath = `${filePath}.backup`;
    try {
      await fs.copyFile(filePath, backupPath);
      return backupPath;
    } catch (error) {
      throw new Error(`Failed to create backup for ${filePath}: ${(error as Error).message}`);
    }
  }

  /**
   * Validate Delphi file extension
   */
  isDelphiFile(filePath: string): boolean {
    const ext = path.extname(filePath).toLowerCase();
    return ['.pas', '.dpr', '.dpk', '.inc', '.dfm', '.fmx'].includes(ext);
  }

  /**
   * Get relative path from base directory
   */
  getRelativePath(filePath: string, baseDir: string): string {
    return path.relative(baseDir, filePath);
  }

  /**
   * Ensure directory exists
   */
  async ensureDirectory(dirPath: string): Promise<void> {
    try {
      await fs.mkdir(dirPath, { recursive: true });
    } catch (error) {
      throw new Error(`Failed to create directory ${dirPath}: ${(error as Error).message}`);
    }
  }

  /**
   * Get file extension without dot
   */
  getFileExtension(filePath: string): string {
    return path.extname(filePath).slice(1).toLowerCase();
  }

  /**
   * Read directory contents
   */
  async readDirectory(dirPath: string): Promise<string[]> {
    try {
      const items = await fs.readdir(dirPath);
      return items;
    } catch (error) {
      throw new Error(`Failed to read directory ${dirPath}: ${(error as Error).message}`);
    }
  }

  /**
   * Check if path is a directory
   */
  async isDirectory(path: string): Promise<boolean> {
    try {
      const stats = await fs.stat(path);
      return stats.isDirectory();
    } catch {
      return false;
    }
  }

  /**
   * Get file modification time
   */
  async getModificationTime(filePath: string): Promise<Date> {
    try {
      const stats = await fs.stat(filePath);
      return stats.mtime;
    } catch (error) {
      throw new Error(`Failed to get modification time for ${filePath}: ${(error as Error).message}`);
    }
  }
}
