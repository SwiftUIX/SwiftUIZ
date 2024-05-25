//
//  EnvironmentValuesMacro.swift & EnvironmentValueMacro.swift
//  SwiftUIZ
//
//  Originally created by Wouter Hennen on 12/06/2023.
//
//  This file is based on the SwiftUI-Macros library.
//  Originally available at: https://github.com/Wouter01/SwiftUI-Macros
//
//  MIT License
//
//  Copyright (c) 2023 Wouter Hennen
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct EnvironmentValueMacro: AttachedMacro {
    
}

public struct EnvironmentValuesMacro {
    
}

extension EnvironmentValueMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard var binding = varDecl.bindings.first else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.missingAnnotation
                )
            )
            
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.notAnIdentifier
                )
            )
            
            return []
        }
        
        binding.pattern = PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("defaultValue")))
        
        let isOptionalType = binding.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
        let hasDefaultValue = binding.initializer != nil
        
        guard isOptionalType || hasDefaultValue else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.noDefaultArgument
                )
            )
            
            return []
        }
        
        return [
            """
            internal struct EnvironmentKey_\(raw: identifier): EnvironmentKey {
                static var \(binding)
            }
            """
        ]
    }
}

extension EnvironmentValueMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard let binding = varDecl.bindings.first else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.missingAnnotation
                )
            )
            
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.notAnIdentifier
                )
            )
            
            return []
        }
        
        return [
            """
            get {
                self[EnvironmentKey_\(raw: identifier).self]
            }
            """,
            """
            set {
                self[EnvironmentKey_\(raw: identifier).self] = newValue
            }
            """
        ]
    }
}

extension EnvironmentValuesMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard member.is(VariableDeclSyntax.self) else {
            return []
        }
        
        return [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: .identifier("EnvironmentValue"))
            )
        ]
    }
}

// MARK: - Diagnostics

fileprivate enum DiagnosticMessage: String, SwiftDiagnostics.DiagnosticMessage {
    case noDefaultArgument
    case missingAnnotation
    case notAnIdentifier
    
    var severity: DiagnosticSeverity {
        return .error
    }
    
    var message: String {
        switch self {
            case .noDefaultArgument:
                "No default value provided."
            case .missingAnnotation:
                "No annotation provided."
            case .notAnIdentifier:
                "Identifier is not valid."
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "com.vmanot.SwiftUIZ", id: rawValue)
    }
}
