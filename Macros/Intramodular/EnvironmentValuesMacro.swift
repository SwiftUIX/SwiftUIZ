//
//  EnvironmentValueMacro.swift
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

public struct EnvironmentValuesMacro: MemberAttributeMacro {
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
