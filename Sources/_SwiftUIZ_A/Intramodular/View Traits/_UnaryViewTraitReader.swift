//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

@frozen
public struct _UnaryViewReader<Content: View, _Body: View>: View {
    @usableFromInline
    let content: Content
    @usableFromInline
    let _body: (_SwiftUI_VariadicView<Content>.Child) -> _Body
    
    public var body: some View {
        _VariadicViewAdapter(self.content) { (content) -> _ConditionalContent<_Body, EmptyView> in
            let _: Void = _validate(content.children)
            
            if let view = content.children.first {
                self._body(view)
            } else {
                EmptyView()
            }
        }
    }
    
    public init(
        _ content: Content,
        _ body: @escaping (_SwiftUI_VariadicView<Content>.Child) -> _Body
    ) {
        self.content =  content
        self._body = body
    }

    private func _validate(_ children: _VariadicViewChildren) {
        guard children.count == 1 else {
            runtimeIssue("_UnaryViewTraitReader expected to read a single view for \(Content.self), but got: \(children.count)")
            
            return
        }
    }
}

public struct _UnaryViewTraitReader<Key: SwiftUI._ViewTraitKey, Content: View>: View {
    let key: Key.Type
    let content: Content
    let action: (Key.Value) -> Void
    
    public var body: some View {
        _VariadicViewAdapter(self.content) { content in
            let _: Void = _validate(content.children)
            
            if let view = content.children.first {
                let trait = view[key]
                let _: Void = action(trait)
                
                self.content
            }
        }
    }
    
    private func _validate(_ children: _VariadicViewChildren) {
        guard children.count == 1 else {
            runtimeIssue("_UnaryViewTraitReader expected to read a single view, but got: \(children.count)")
            
            return
        }
    }
}

extension _UnaryViewTraitReader {
    public init(
        _ key: Key.Type,
        @ViewBuilder content: () -> Content,
        action: @escaping (Key.Value) -> Void
    ) where Key: SwiftUI._ViewTraitKey {
        self.key =  key
        self.content = content()
        self.action = action
    }
    
    public init(
        _ key: Key,
        @ViewBuilder content: () -> Content,
        action: @escaping (Key.Value) -> Void
    ) where Key: SwiftUI._ViewTraitKey {
        self.key = type(of: key)
        self.content = content()
        self.action = action
    }

    public init<T>(
        _ type: T.Type,
        @ViewBuilder content: () -> Content,
        action: @escaping (Key.Value) -> Void
    ) where Key == _TypeToViewTraitKeyAdaptor<T> {
        self.key =  _TypeToViewTraitKeyAdaptor<T>.self
        self.content = content()
        self.action = action
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension _UnaryViewTraitReader where Key == _SwiftUIX_ViewTraitValues._ViewTraitKey {
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping (Key.Value) -> Void
    )  {
        self.key =  Key.self
        self.content = content()
        self.action = action
    }
}
