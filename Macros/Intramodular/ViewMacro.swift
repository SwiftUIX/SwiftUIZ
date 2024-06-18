//
// Copyright (c) Vatsal Manot
//

import MacroBuilder
import Swallow
import SwiftSyntax

extension ViewMacro: MemberMacro {
    static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, .structDecl].contains(declaration.kind) else {
            throw _Error()
        }
        
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let _viewBodyVariable: VariableDeclSyntax? = declaration.memberBlock.members.lazy
            .compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            .filter {
                $0.bindings.first?
                    .pattern
                    .trimmedDescription
                    .contains("body") ?? false
            }
            .first
        
        guard let viewBodyVariable: VariableDeclSyntax = _viewBodyVariable else {
            throw CustomStringError("invalid")
        }
        
        guard let declaration = viewBodyVariable.bindings.first!.accessorBlock?.accessors._syntaxNode else {
            throw CustomStringError("invalid")
        }
        
        return [
            // DeclSyntax("public typealias Provide<T, U> = _View_Provide<Self, T, U>"),
            // DeclSyntax("public typealias Require<T> = _View_Require<T>"),
            DeclSyntax("public typealias Body = AnyView"),
            DeclSyntax("@_DynamicReplacementObserver public var _dynamicReplacementObserver"),
            DeclSyntax(
                """
                @_implements(View, body)
                @ViewBuilder
                public var _actualViewBody: AnyView {
                    Group {
                        \(declaration)
                    }
                    .eraseToAnyView()
                }
                """
            )
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
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let alreadyHasViewConformance: Bool = declaration.inheritanceClause?.inheritedTypes.contains(where: { $0.trimmedDescription == "View" }) ?? false
        
        let newConformances: ExprSyntax = alreadyHasViewConformance ? "DynamicView" : "View, DynamicView"
        
        let result = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): CustomSourceDeclarationReflectable, \(newConformances) {
                public static var customSourceDeclarationMirror: _StaticSwift.SourceDeclarationMirror {
                    .init(file: #file, function: #function, line: #line, column: nil)
                }
            }
            """
        )
        
        return [result]
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
