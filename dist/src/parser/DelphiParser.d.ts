export interface DelphiUnit {
    name: string;
    uses: string[];
    types: DelphiType[];
    constants: DelphiConstant[];
    variables: DelphiVariable[];
    functions: DelphiFunction[];
    procedures: DelphiProcedure[];
    classes: DelphiClass[];
}
export interface DelphiType {
    name: string;
    definition: string;
    kind: 'record' | 'enum' | 'alias' | 'pointer' | 'array';
}
export interface DelphiConstant {
    name: string;
    type?: string;
    value: string;
}
export interface DelphiVariable {
    name: string;
    type: string;
    isGlobal: boolean;
}
export interface DelphiFunction {
    name: string;
    returnType: string;
    parameters: DelphiParameter[];
    body: string;
    isPublic: boolean;
}
export interface DelphiProcedure {
    name: string;
    parameters: DelphiParameter[];
    body: string;
    isPublic: boolean;
}
export interface DelphiParameter {
    name: string;
    type: string;
    isVar: boolean;
    isConst: boolean;
    defaultValue?: string;
}
export interface DelphiClass {
    name: string;
    baseClass?: string;
    interfaces: string[];
    fields: DelphiField[];
    properties: DelphiProperty[];
    methods: DelphiMethod[];
    visibility: 'public' | 'private' | 'protected' | 'published';
}
export interface DelphiField {
    name: string;
    type: string;
    visibility: 'public' | 'private' | 'protected' | 'published';
}
export interface DelphiProperty {
    name: string;
    type: string;
    getter?: string;
    setter?: string;
    visibility: 'public' | 'private' | 'protected' | 'published';
}
export interface DelphiMethod {
    name: string;
    returnType?: string;
    parameters: DelphiParameter[];
    body: string;
    visibility: 'public' | 'private' | 'protected' | 'published';
    isConstructor: boolean;
    isDestructor: boolean;
    isVirtual: boolean;
    isOverride: boolean;
}
/**
 * Parser for Delphi source code
 */
export declare class DelphiParser {
    /**
     * Parse Delphi source code and extract structure
     */
    parse(source: string): DelphiUnit;
    /**
     * Extract unit name from source
     */
    private extractUnitName;
    /**
     * Extract uses clause
     */
    private extractUses;
    /**
     * Extract type definitions
     */
    private extractTypes;
    /**
     * Extract constants
     */
    private extractConstants;
    /**
     * Extract global variables
     */
    private extractVariables;
    /**
     * Extract functions
     */
    private extractFunctions;
    /**
     * Extract procedures
     */
    private extractProcedures;
    /**
     * Extract classes (simplified)
     */
    private extractClasses;
    /**
     * Extract a specific section (type, const, var, etc.)
     */
    private extractSection;
    /**
     * Parse parameter list
     */
    private parseParameters;
    /**
     * Determine the kind of type definition
     */
    private determineTypeKind;
}
//# sourceMappingURL=DelphiParser.d.ts.map