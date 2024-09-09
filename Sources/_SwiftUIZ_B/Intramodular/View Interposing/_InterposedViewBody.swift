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
    @Environment(\._interposeContext) private var _interposeContext: EnvironmentValues._InterposeGraphContext
    
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    @ViewStorage private var graphInsertion: ViewGraphInsertion!
    @StateObject private var _storage = _InterposedViewBodyStorage()
    @StateObject private var _viewBridge = _InterposedViewBodyBridge(
        _swiftType: Root.self,
        _bodyStorage: nil
    )

    private var projectedProxy: _InterposedViewBodyProxy? {
        guard !_interposeContext._isInvalidInstance else {
            return nil
        }
        
        return _InterposedViewBodyProxy(
            _viewBridge: _viewBridge,
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
            graphInsertion: graphInsertion,
            viewBodyProxy: projectedProxy,
            content: content
        )
        .transformEnvironment(\.self) { environment in
            graphInsertion.transformEnvironment(&environment)
        }
        ._host(_viewBridge)
        ._SwiftUIX_trait(
            _InterposedViewBodyProxy.HydrationSurface.self,
            _InterposedViewBodyProxy.HydrationSurface(bridge: _viewBridge)!
        )
    }
    
    func initialize() throws {
        _viewBridge._bodyStorage = _storage
        
        if graphInsertion == nil {
            graphInsertion = try ViewGraphInsertion(
                for: root,
                in: self._interposeContext.graph
            )
            
            _storage.graphInsertion = graphInsertion
            
            Task.detached { @MainActor in
                _viewBridge.objectWillChange.send()
            }
        }
    }
}

extension _InterposedViewBody {
    struct ResolveBody: View {
        let graphInsertion: ViewGraphInsertion?
        let viewBodyProxy: _InterposedViewBodyProxy?
        let content: Content
        
        var body: some View {
            if let viewBodyProxy {
                let _: Void = {
                    #try(.optimistic) {
                        try viewBodyProxy._resolveViewBodyUsing_HeavyweightViewHypergraph()
                    }
                }()
                
                if viewBodyProxy._isViewBodyResolved {
                    if let swizzledContent: any View = graphInsertion?.insertedObject.swizzledViewBody {
                        swizzledContent.eraseToAnyView()
                    } else {
                        content
                    }
                } else {
                    InterposeFailureDisclosure(proxy: viewBodyProxy)
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
