//
// Copyright (c) Vatsal Manot
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        _ViewTraitKeyMacro.self,
        _ViewTraitValueMacro.self,
        EnvironmentValuesMacro.self,
        EnvironmentValueMacro.self
    ]
}
