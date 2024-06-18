//
// Copyright (c) Vatsal Manot
//

@_exported import SwiftUIX
@_exported import _SwiftUIZ_A
@_exported import _SwiftUIZ_B

@attached(
    member,
    names: named(init), named(_actualViewBody), named(_dynamicReplacementObserver), named(Body), named(Require), named(Provide), named(Text)
)
@attached(
    extension,
    conformances: CustomSourceDeclarationReflectable, View, DynamicView,
    names: named(customSourceDeclarationMirror)
)
@attached(peer, names: overloaded)
public macro View(_ keyword: _SwiftUIZ_ViewMacroKeyword) = #externalMacro(
    module: "SwiftUIZ_Macros",
    type: "ViewMacro"
)

@freestanding(declaration, names: named(body))
public macro body<R: View>(
    _: () -> R
) = #externalMacro(
    module: "SwiftUIZ_Macros",
    type: "ViewBodyMacro"
)

extension AnyView {
    public static func _erase<T: View>(
        @ViewBuilder _ content: () -> T
    ) -> Self {
        AnyView(content())
    }
}

// MARK: - Auxiliary

public struct _SwiftUIZ_ViewMacroKeyword: _StaticType {
    public static let dynamic: Self = .init()
}
