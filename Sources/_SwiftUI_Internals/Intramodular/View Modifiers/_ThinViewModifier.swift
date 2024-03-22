//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

/// `ViewModifier` without SwiftUI runtime fuckery.
///
/// Needed to workaround issues with traits not being propagated correctly.
public protocol _ThinViewModifier<Content>: DynamicProperty {
    associatedtype Content: View
    associatedtype Body: View

    @MainActor
    @ViewBuilder
    func body(content: Content) -> Body
}

public protocol _ThinForceViewModifier<Root, Content>: DynamicProperty {
    associatedtype Root: View
    associatedtype Content: View
    associatedtype Body: View
    
    @MainActor
    @ViewBuilder
    func body(root: Root, content: LazyView<Content>) -> Body
}

// MARK: - Supplementary

extension View {
    public func _modifier<Modifier: _ThinViewModifier<Self>>(
        _ modifier: Modifier
    ) -> some View {
        _ThinModifiedView(content: self, modifier: modifier)
    }
}

// MARK: - Auxiliary

@frozen
public struct _ThinModifiedView<Content: View, Modifier: _ThinViewModifier<Content>>: View {
    public let content: Content
    public let modifier: Modifier
    
    @_transparent
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    public var body: some View {
        modifier.body(content: content)
    }
}
