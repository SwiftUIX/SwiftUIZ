//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A view that is detached (i.e. not rendered) but can still be used to read traits.
public struct _ReadDetachedView<Content: View>: View {
    let content: Content
    let inspect: (DetatchedViewProxy<Content>) -> Void
    
    @ViewStorage var proxy: DetatchedViewProxy<Content>?
    
    public init(
        _ content: Content,
        inspect: @escaping (DetatchedViewProxy<Content>) -> Void
    ) {
        self.content = content
        self.inspect = inspect
    }
    
    public var body: some View {
        _VariadicViewAdapter {
            content
                .environment(
                    \._traitsResolutionContext,
                     _ViewTraitsResolutionContext(mode: .traitOnly)
                )
                .eraseToAnyView()
        } content: { children in
            PerformAction(deferred: false) {
                let proxy = DetatchedViewProxy<Content>(base: children)
                
                if !_isKnownEqual(proxy, self.proxy) {
                    self.proxy = proxy
                    
                    inspect(.init(base: children))
                } else {
                    _ = proxy
                }
            }
        }
    }
}

public struct DetatchedViewProxy<Content: View>: _PartiallyEquatable {
    let base: _SwiftUIX_ViewTraitValues
    
    init(base: _SwiftUI_VariadicView<AnyView>) {
        self.base = base.children.first?.traits._SwiftUIX_viewTraitValues ?? .init()
    }
    
    public func isEqual(to other: Self) -> Bool? {
        base.isEqual(to: other.base)
    }
    
    public subscript<Key: _SwiftUIX_ViewTraitKey>(
        _ key: Key
    ) -> Key.Value {
        get {
            base[key]
        }
    }
    
    public subscript<T>(
        _ type: T.Type
    ) -> T? {
        get {
            self[_SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<T>()]
        }
    }
    
    public subscript<T: ExpressibleByNilLiteral>(
        _ type: T.Type
    ) -> T {
        get {
            self[_SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<T>()] ?? nil
        }
    }
}
