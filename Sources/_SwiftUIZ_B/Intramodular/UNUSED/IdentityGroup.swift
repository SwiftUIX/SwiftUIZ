//
// Copyright (c) Vatsal Manot
//

import Diagnostics
@_spi(Internal) import SwiftUIX

public struct IdentityGroup<Content: View>: View {
    @State private var id = _ViewIdentity.ID()
    @_LazyState private var resolver = _ViewIdentityResolver()
    @State private var identityState = _ViewIdentityState()
    
    public let content: ((IdentityGroupProxy) -> Content)
    
    public init(@ViewBuilder content: @escaping (IdentityGroupProxy) -> Content) {
        self.content = content
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = { _ in content() }
    }
    
    var _viewIdentity: _ViewIdentity {
        _ViewIdentity(
            _unsafeProxy: .init(_resolver: resolver),
            id: id,
            generation: identityState.generation,
            path: []
        )
    }
    
    public var body: some View {
        let proxy = IdentityGroupProxy(_resolver: resolver)
        
        IdentityGroupProxy.$current._makeViewWithValue(proxy) {
            _SwiftUI_UnaryViewAdaptor {
                content(.init(_resolver: resolver))
                    .environment(\._parentView, _viewIdentity)
            }
            ._trait(\._viewIdentity, _ViewIdentityTrait(id: id))
            .environment(\._parentView, _viewIdentity)
        } start: {
            resolver._identityStateBinding = $identityState
            
            resolver.begin()
        } end: {
            DispatchQueue.main.async {
                resolver.end()
            }
        }
        .background {
            ZeroSizeView()
                .id(identityState)
        }
    }
}

public struct _InstantIdentityGroup<Content: View>: View {
    @State private var id = _ViewIdentity.ID()
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        _SwiftUI_UnaryViewAdaptor {
            content
        }
        ._trait(\._viewIdentity, _ViewIdentityTrait(id: id))
    }
}

public struct _UnsafeContainerBound {
    let proxy: IdentityGroupProxy
    let path: [_ViewIdentity.Path]
}

extension View {
    public func bounds(_ boundary: _UnsafeContainerBound) -> some View {
        self._viewParameters {
            $0[IdentityGroupProxy.self] = boundary.proxy
        }
    }
}

public struct _UnsafeContainerBoundary<Content: View>: View {
    @Environment(\._parentView) var _parentView
    
    public var proxy = IdentityGroupProxy.current
    
    let content: (_UnsafeContainerBound) -> Content
    let path: _ViewIdentity.Path
    
    public init<T: _SwiftUI_WithPlaceholderGenericTypeParameters>(
        _ path: T.Type,
        @ViewBuilder content: @escaping (_UnsafeContainerBound) -> Content
    ) {
        self.content = content
        self.path = .init(path)
    }
    
    public var body: some View {
        if let proxy = proxy ?? _parentView?._unsafeProxy {
            content(.init(proxy: proxy, path: [path]))
                .transformEnvironment(\._parentView) {
                    assertNotNil($0)
                    
                    $0?.path.append(path)
                }
                ._viewParameters {
                    $0[IdentityGroupProxy.self] = proxy
                }
        } else {
            _UnimplementedView()
        }
    }
}

// MARK: - API

extension View {
    public func distinct() -> some View {
        _InstantIdentityGroup {
            self
        }
    }
}
