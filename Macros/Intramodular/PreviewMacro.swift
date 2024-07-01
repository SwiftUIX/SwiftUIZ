//
// Copyright (c) Vatsal Manot
//

import MacroBuilder

struct PreviewMacro {
    
}

extension PreviewMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let alreadyHasViewConformance: Bool = declaration.inheritanceClause?.inheritedTypes.contains(where: { $0.trimmedDescription == "View" }) ?? false
        let newConformances: ExprSyntax = alreadyHasViewConformance ? "ViewPreview" : "View, ViewPreview"
        let previewTitleGetter: String = "String(describing: Self.self)"
        
        let result = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): \(newConformances) {
                public static var title: String {
                   \(raw: previewTitleGetter)
                }
            }
            """
        )
        
        return [result]
    }
}

extension PreviewMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try RuntimeDiscoverableMacroPrototype.expansion(
            of: node,
            providingPeersOf: declaration,
            in: context
        )
    }
}
