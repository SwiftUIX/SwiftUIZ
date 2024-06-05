//
// Copyright (c) Vatsal Manot
//

@_exported import SwiftUIX
@_exported import _SwiftUIZ_A
@_exported import _SwiftUIZ_B

public struct _ViewMacroKeyword {
    public static let dynamic: Self = .init()
}

@attached(
    member,
    names: named(init),
    named(_dynamicReplacementObserver),
    named(Require),
    named(Provide),
    named(Text)
)
@attached(extension, conformances: View, DynamicView, names: arbitrary)
@attached(peer, names: overloaded)
public macro View(_ keyword: _ViewMacroKeyword) = #externalMacro(
    module: "SwiftUIZ_Macros",
    type: "ViewMacro"
)
