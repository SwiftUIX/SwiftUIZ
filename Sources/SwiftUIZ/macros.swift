//
// Copyright (c) Vatsal Manot
//

import Swift

@attached(peer, names: suffixed(_ViewTraitKey))
@attached(extension, names: arbitrary)
public macro _ViewTrait() = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitValueMacro")

@attached(member, names: arbitrary)
public macro _ViewTraitKey<T>(for: T.Type, named: String) = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitKeyMacro")

@attached(peer, names: suffixed(_ViewTraitKey))
@attached(extension, names: arbitrary)
public macro _ViewTrait(_: String) = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitValueMacro")

/// Credits:
/// - https://github.com/Wouter01/SwiftUI-Macros/tree/main
@attached(peer, names: prefixed(EnvironmentKey_))
@attached(accessor, names: named(get), named(set))
public macro EnvironmentValue() = #externalMacro(module: "SwiftUIZ_Macros", type: "EnvironmentValueMacro")

@attached(memberAttribute)
public macro EnvironmentValuesMacro() = #externalMacro(module: "SwiftUIZ_Macros", type: "EnvironmentValuesMacro")
