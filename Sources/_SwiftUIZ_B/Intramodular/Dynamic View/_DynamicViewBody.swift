//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import SwallowMacrosClient
@_spi(Internal) import _SwiftUIX
@_spi(Internal) import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

@frozen
public struct _DynamicViewBody<Root: DynamicView, Content: View>: View {
    @Environment(\._viewGraphContext) private var _viewGraphContext: _DynamicViewGraphContext
    
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    @StateObject private var _storage = _DynamicViewBodyStorage()
    @StateObject private var _dynamicViewBridge = _DynamicViewBridge(
        _swiftType: Root.self,
        _bodyStorage: nil
    )

    private var projectedProxy: _DynamicViewProxy? {
        guard !_viewGraphContext._isInvalidInstance else {
            return nil
        }
        
        return _DynamicViewProxy(
            _dynamicViewBridge: _dynamicViewBridge,
            _storage: _storage,
            root: root,
            content: content,
            graphContext: _viewGraphContext
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
            _dynamicViewGraphInsertion: _storage._dynamicViewGraphInsertion,
            viewProxy: projectedProxy,
            content: content
        )
        .transformEnvironment(\.self) { environment in
            _storage._dynamicViewGraphInsertion.transformEnvironment(&environment)
        }
        ._host(_dynamicViewBridge)
        ._SwiftUIX_trait(
            _DynamicViewProxy.HydrationSurface.self,
            _DynamicViewProxy.HydrationSurface(bridge: _dynamicViewBridge)!
        )
    }
    
    func initialize() throws {
        _dynamicViewBridge._bodyStorage = _storage
        
        if _storage._dynamicViewGraphInsertion == nil {
            _storage._dynamicViewGraphInsertion = try _DynamicViewGraphInsertion(
                for: root,
                in: self._viewGraphContext.graph
            )
            
            DispatchQueue.main.async {
                _dynamicViewBridge.objectWillChange.send()
            }
        }
    }
}

extension _DynamicViewBody {
    struct ResolveBody: View {
        let _dynamicViewGraphInsertion: _DynamicViewGraphInsertion?
        let viewProxy: _DynamicViewProxy?
        let content: Content
        
        var body: some View {
            if let viewProxy {
                let _: Void = {
                    #try(.optimistic) {
                        try viewProxy._resolveViewBodyUsingDynamicViewGraph()
                    }
                }()
                
                if viewProxy._isViewBodyResolved {
                    if let swizzledContent: any View = _dynamicViewGraphInsertion?.node.swizzledViewBody {
                        swizzledContent.eraseToAnyView()
                    } else {
                        content
                    }
                } else {
                    _UnresolvedDynamicViewPlaceholder(proxy: viewProxy)
                }
            } else {
                content
            }
        }
    }
}
