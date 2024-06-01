//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import SwallowMacrosClient
@_spi(Internal) import _SwiftUIX
@_spi(Internal) import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

/// A view that interposes a target view's body.
@frozen
public struct _InterposedViewBody<Root: DynamicView, Content: View>: View {
    @Environment(\._interposeContext) private var _interposeContext: EnvironmentValues._InterposeContext
    
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    @ViewStorage private var _viewGraphInsertion: ViewGraphInsertion!
    @StateObject private var _storage = _InterposedViewBodyStorage()
    @StateObject private var _dynamicViewBridge = _InterposedViewBodyBridge(
        _swiftType: Root.self,
        _bodyStorage: nil
    )

    private var projectedProxy: _InterposedViewBodyProxy? {
        guard !_interposeContext._isInvalidInstance else {
            return nil
        }
        
        return _InterposedViewBodyProxy(
            _dynamicViewBridge: _dynamicViewBridge,
            _storage: _storage,
            root: root,
            content: content,
            graphContext: _interposeContext
        )
    }
    
    public init(
        root: Root,
        @ViewBuilder content: () -> Content
    ) {
        self.root = root
        self.content = content()
    }
    
    public var body: some View {
        let _: Void? = #try(.optimistic) {
            try initialize()
        }
        
        ResolveBody(
            _viewGraphInsertion: _viewGraphInsertion,
            viewProxy: projectedProxy,
            content: content
        )
        .transformEnvironment(\.self) { environment in
            _viewGraphInsertion.transformEnvironment(&environment)
        }
        ._host(_dynamicViewBridge)
        ._SwiftUIX_trait(
            _InterposedViewBodyProxy.HydrationSurface.self,
            _InterposedViewBodyProxy.HydrationSurface(bridge: _dynamicViewBridge)!
        )
    }
    
    func initialize() throws {
        _dynamicViewBridge._bodyStorage = _storage
        
        if _viewGraphInsertion == nil {
            _viewGraphInsertion = try ViewGraphInsertion(
                for: root,
                in: self._interposeContext.graph
            )
            
            _storage._viewGraphInsertion = _viewGraphInsertion
            
            DispatchQueue.main.async {
                _dynamicViewBridge.objectWillChange.send()
            }
        }
    }
}

extension _InterposedViewBody {
    struct ResolveBody: View {
        let _viewGraphInsertion: ViewGraphInsertion?
        let viewProxy: _InterposedViewBodyProxy?
        let content: Content
        
        var body: some View {
            if let viewProxy {
                let _: Void = {
                    #try(.optimistic) {
                        try viewProxy._resolveViewBodyUsing_HeavyweightViewHypergraph()
                    }
                }()
                
                if viewProxy._isViewBodyResolved {
                    if let swizzledContent: any View = _viewGraphInsertion?.insertedObject.swizzledViewBody {
                        swizzledContent.eraseToAnyView()
                    } else {
                        content
                    }
                } else {
                    InterposeFailureDisclosure(proxy: viewProxy)
                }
            } else {
                content
            }
        }
    }
}

extension _InterposedViewBody {
    package struct InterposeFailureDisclosure: View {
        let proxy: _InterposedViewBodyProxy?
        
        package var body: some View {
            ZeroSizeView()
                .overlay {
                    Text("Failed to resolve view!\n(com.vmanot.SwiftUIZ)")
                        .fixedSize()
                        .border(Color.red)
                }
        }
    }
}
