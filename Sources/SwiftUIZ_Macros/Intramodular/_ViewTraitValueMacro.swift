//
// Copyright (c) Vatsal Manot
//

import MacroBuilder
import SwiftSyntaxUtilities
import Swallow

public enum _ViewTraitValueMacro {
    
}

extension _ViewTraitValueMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declaration = try declaration.asProtocol(NamedDeclSyntax.self).unwrap()
        
        let name = declaration.name.text
        
        let syntax = DeclSyntax(
            """
            public struct \(raw: name)_ViewTraitKey: _ViewTraitKey {
                public static var defaultValue: Optional<\(raw: name)> {
                    nil
                }
            }
            """
        )
        
        return [syntax]
    }
}

extension _ViewTraitValueMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let declaration = declaration.asProtocol(NamedDeclSyntax.self) else {
            throw _PlaceholderError()
        }
                
        return [
            try ExtensionDeclSyntax(
                """
                extension \(raw: declaration.name.text) {
                    public typealias _ViewTraitKeyType = \(raw: declaration.name.text)_ViewTraitKey
                }
                """
            )
        ]
    }
}
