//
// Copyright (c) Vatsal Manot
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnvironmentValuesMacro.self,
        EnvironmentValueMacro.self,
        ViewMacro.self,
        _ViewTraitKeyMacro.self,
        _ViewTraitValueMacro.self,
    ]
}
