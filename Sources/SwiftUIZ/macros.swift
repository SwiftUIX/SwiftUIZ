//
// Copyright (c) Vatsal Manot
//

@_exported import SwiftUIX
@_exported import _SwiftUIZ_A
@_exported import _SwiftUIZ_B

// MARK: - `@View`

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

// MARK: - `@Preview`

@attached(peer, names: suffixed(_RuntimeTypeDiscovery))
@attached(
    extension,
    conformances: View, ViewPreview,
    names: named(title)
)
public macro Preview() = #externalMacro(
    module: "SwiftUIZ_Macros",
    type: "PreviewMacro"
)

// MARK: - `#body`

@freestanding(declaration, names: named(body))
public macro body<R: View>(
    _: () -> R
) = #externalMacro(
    module: "SwiftUIZ_Macros",
    type: "ViewBodyMacro"
)

// MARK: - Auxiliary

public struct _SwiftUIZ_ViewMacroKeyword: _StaticType {
    public static let dynamic: Self = .init()
}

extension AnyView {
    public static func _erase<T: View>(
        @ViewBuilder _ content: () -> T
    ) -> Self {
        AnyView(content())
    }
}
