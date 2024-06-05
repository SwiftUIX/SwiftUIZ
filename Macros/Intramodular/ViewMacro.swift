//
// Copyright (c) Vatsal Manot
//

import MacroBuilder

extension ViewMacro: MemberMacro {
    static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, .structDecl].contains(declaration.kind) else {
            throw _Error()
        }
        
        return [
            // DeclSyntax("public typealias Provide<T, U> = _View_Provide<Self, T, U>"),
            // DeclSyntax("public typealias Require<T> = _View_Require<T>"),
            DeclSyntax("@_DynamicReplacementObserver public var _dynamicReplacementObserver"),
        ]
    }
}

extension ViewMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {        
        let declaration = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): View, DynamicView {
            
            }
            """
        )
        
        return [declaration]
    }
}

extension ViewMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}

struct ViewMacro {
    struct _Error: Error {
        
    }
}
