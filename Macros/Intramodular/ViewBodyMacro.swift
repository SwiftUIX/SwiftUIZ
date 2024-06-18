//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxUtilities

public struct ViewBodyMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard node.arguments.isEmpty else {
            throw Never.Reason.illegal
        }
        
        guard let trailingClosure = node.trailingClosure else {
            throw Never.Reason.illegal
        }
        
        let result = DeclSyntax(
            """
            public var body: AnyView {
                let `self` = self
            
                Group \(trailingClosure).eraseToAnyView()
            }
            """
        )
        
        return [result]
    }
}
