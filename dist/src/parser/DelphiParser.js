"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DelphiParser = void 0;
/**
 * Parser for Delphi source code
 */
class DelphiParser {
    /**
     * Parse Delphi source code and extract structure
     */
    parse(source) {
        const unit = {
            name: this.extractUnitName(source),
            uses: this.extractUses(source),
            types: this.extractTypes(source),
            constants: this.extractConstants(source),
            variables: this.extractVariables(source),
            functions: this.extractFunctions(source),
            procedures: this.extractProcedures(source),
            classes: this.extractClasses(source)
        };
        return unit;
    }
    /**
     * Extract unit name from source
     */
    extractUnitName(source) {
        const unitMatch = source.match(/unit\s+(\w+)\s*;/i);
        return unitMatch ? unitMatch[1] : 'UnknownUnit';
    }
    /**
     * Extract uses clause
     */
    extractUses(source) {
        const usesMatch = source.match(/uses\s+([\s\S]*?);/i);
        if (!usesMatch)
            return [];
        return usesMatch[1]
            .split(',')
            .map(unit => unit.trim())
            .filter(unit => unit.length > 0);
    }
    /**
     * Extract type definitions
     */
    extractTypes(source) {
        const types = [];
        const typeSection = this.extractSection(source, 'type');
        if (typeSection) {
            // Simple pattern matching for basic types
            const typePattern = /(\w+)\s*=\s*([^;]+);/g;
            let match;
            while ((match = typePattern.exec(typeSection)) !== null) {
                types.push({
                    name: match[1],
                    definition: match[2].trim(),
                    kind: this.determineTypeKind(match[2])
                });
            }
        }
        return types;
    }
    /**
     * Extract constants
     */
    extractConstants(source) {
        const constants = [];
        const constSection = this.extractSection(source, 'const');
        if (constSection) {
            const constPattern = /(\w+)\s*(?::\s*([^=]+))?\s*=\s*([^;]+);/g;
            let match;
            while ((match = constPattern.exec(constSection)) !== null) {
                constants.push({
                    name: match[1],
                    type: match[2]?.trim(),
                    value: match[3].trim()
                });
            }
        }
        return constants;
    }
    /**
     * Extract global variables
     */
    extractVariables(source) {
        const variables = [];
        const varSection = this.extractSection(source, 'var');
        if (varSection) {
            const varPattern = /(\w+(?:\s*,\s*\w+)*)\s*:\s*([^;]+);/g;
            let match;
            while ((match = varPattern.exec(varSection)) !== null) {
                const names = match[1].split(',').map(n => n.trim());
                const type = match[2].trim();
                names.forEach(name => {
                    variables.push({
                        name,
                        type,
                        isGlobal: true
                    });
                });
            }
        }
        return variables;
    }
    /**
     * Extract functions
     */
    extractFunctions(source) {
        const functions = [];
        const functionPattern = /function\s+(\w+)(\([^)]*\))?\s*:\s*([^;]+);([\s\S]*?)(?=(?:function|procedure|end\.|$))/gi;
        let match;
        while ((match = functionPattern.exec(source)) !== null) {
            functions.push({
                name: match[1],
                returnType: match[3].trim(),
                parameters: this.parseParameters(match[2] || ''),
                body: match[4].trim(),
                isPublic: true
            });
        }
        return functions;
    }
    /**
     * Extract procedures
     */
    extractProcedures(source) {
        const procedures = [];
        const procedurePattern = /procedure\s+(\w+)(\([^)]*\))?\s*;([\s\S]*?)(?=(?:function|procedure|end\.|$))/gi;
        let match;
        while ((match = procedurePattern.exec(source)) !== null) {
            procedures.push({
                name: match[1],
                parameters: this.parseParameters(match[2] || ''),
                body: match[3].trim(),
                isPublic: true
            });
        }
        return procedures;
    }
    /**
     * Extract classes (simplified)
     */
    extractClasses(source) {
        const classes = [];
        const classPattern = /(\w+)\s*=\s*class(\([^)]+\))?\s*([\s\S]*?)end\s*;/gi;
        let match;
        while ((match = classPattern.exec(source)) !== null) {
            classes.push({
                name: match[1],
                baseClass: match[2]?.replace(/[()]/g, '').trim(),
                interfaces: [],
                fields: [],
                properties: [],
                methods: [],
                visibility: 'public'
            });
        }
        return classes;
    }
    /**
     * Extract a specific section (type, const, var, etc.)
     */
    extractSection(source, sectionName) {
        const pattern = new RegExp(`\\b${sectionName}\\b([\\s\\S]*?)(?=\\b(?:type|const|var|function|procedure|implementation|end\\.)\\b|$)`, 'i');
        const match = source.match(pattern);
        return match ? match[1].trim() : null;
    }
    /**
     * Parse parameter list
     */
    parseParameters(paramStr) {
        const parameters = [];
        if (!paramStr || paramStr === '()')
            return parameters;
        // Remove parentheses
        const cleanParams = paramStr.replace(/[()]/g, '').trim();
        if (!cleanParams)
            return parameters;
        // Split by semicolon for parameter groups
        const paramGroups = cleanParams.split(';');
        paramGroups.forEach(group => {
            const trimmedGroup = group.trim();
            if (!trimmedGroup)
                return;
            const isVar = trimmedGroup.startsWith('var ');
            const isConst = trimmedGroup.startsWith('const ');
            let paramDecl = trimmedGroup;
            if (isVar)
                paramDecl = paramDecl.substring(4);
            if (isConst)
                paramDecl = paramDecl.substring(6);
            const colonIndex = paramDecl.lastIndexOf(':');
            if (colonIndex > 0) {
                const names = paramDecl.substring(0, colonIndex).split(',').map(n => n.trim());
                const type = paramDecl.substring(colonIndex + 1).trim();
                names.forEach(name => {
                    parameters.push({
                        name,
                        type,
                        isVar,
                        isConst
                    });
                });
            }
        });
        return parameters;
    }
    /**
     * Determine the kind of type definition
     */
    determineTypeKind(definition) {
        const def = definition.toLowerCase().trim();
        if (def.includes('record'))
            return 'record';
        if (def.includes('(') && def.includes(')'))
            return 'enum';
        if (def.startsWith('^'))
            return 'pointer';
        if (def.includes('array'))
            return 'array';
        return 'alias';
    }
}
exports.DelphiParser = DelphiParser;
//# sourceMappingURL=DelphiParser.js.map