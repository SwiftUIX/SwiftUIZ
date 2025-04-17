//
// Copyright (c) Vatsal Manot
//

import MacroBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxUtilities

public struct _ViewTraitKeyMacro {
    
}

extension _ViewTraitKeyMacro: _MemberMacro2 {
    private struct _ViewTraitKeyArguments: Codable {
        enum CodingKeys: String, CodingKey {
            case type = "for"
            case name = "named"
        }
        
        let type: String
        let name: String
    }

    public static func _expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let arguments = try node.labeledArguments!.decode(_ViewTraitKeyArguments.self)
        
        return [
            """
            public var \(raw: arguments.name): \(raw: arguments.type)._ViewTraitKeyType.Type {
                return \(raw: arguments.type)._ViewTraitKeyType.self
            }
            """
        ]

    }
}
/*extension _ViewTraitKeyMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            """
                var body: some View {
                        Text("Temp View")
                    }
            """
        ]
    }

extension _ViewTraitKeyMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Skip declarations other than variables
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard var binding = varDecl.bindings.first?.as(PatternBindingSyntax.self)else {
            context.diagnose(Diagnostic(node: Syntax(node), message: _DiagnosticMessage.missingAnnotation))
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(Diagnostic(node: Syntax(node), message: _DiagnosticMessage.notAnIdentifier))
            return []
        }
        
        binding.pattern = PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("defaultValue")))
        
        let isOptionalType = binding.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
        let hasDefaultValue = binding.initializer != nil
        
        guard isOptionalType || hasDefaultValue else {
            context.diagnose(Diagnostic(node: Syntax(node), message: _DiagnosticMessage.noDefaultArgument))
            return []
        }
        
        return [
            """
            internal struct _ViewTraitKey_\(raw: identifier): _ViewTraitKey {
                static var \(binding)
            }
            """
        ]
    }
}*/

/*extension _ViewTraitKeyMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        // Skip declarations other than variables
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard let binding = varDecl.bindings.first?.as(PatternBindingSyntax.self)else {
            context.diagnose(Diagnostic(node: Syntax(node), message: _DiagnosticMessage.missingAnnotation))
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(Diagnostic(node: Syntax(node), message: _DiagnosticMessage.notAnIdentifier))
            return []
        }
        
        return [
            """
            get {
                self[_ViewTraitKey_\(raw: identifier).self]
            }
            """,
            """
            set {
                self[_ViewTraitKey_\(raw: identifier).self] = newValue
            }
            """
        ]
    }
}
*/
