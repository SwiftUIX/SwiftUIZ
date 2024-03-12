//
// Copyright (c) Vatsal Manot
//

import _DVGraph
import Diagnostics
@_spi(Internal) import SwiftUIX

struct _DVViewDescriptor {
    
}

@_spi(Internal)
public final class _DVGraphMembership {
    weak var graph: _DVGraph?
    
    public var node: _DVGraph.Node
    
    public init(
        graph: _DVGraph,
        viewType: _DVViewTypeDescriptor
    ) {
        self.graph = graph
        self.node = _DVGraph.Node()
    }
    
    deinit {
        
    }
}

@_spi(Internal)
@frozen
public struct _ManagedDynamicViewBody<Root: View, Content: View>: View {
    @Environment(\._dynamicViewGraph) private var _dynamicViewGraph: _DVGraph
    
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    public init(
        root: Root,
        @ViewBuilder content: () -> Content
    ) {
        self.root = root
        self.content = content()
    }
    
    @StateObject private var bridge = _DVViewBridge()
    
    public var body: some View {
        let _: Void? = _expectNoThrow {
            try _initializeIfNeeded()
        }
        
        _UnaryViewReader(content) { view in
            content
                .trait(
                    _SwiftUIZ_DynamicViewReceiverContext.self,
                    _SwiftUIZ_DynamicViewReceiverContext(bridge: bridge)
                )
                ._host(bridge)
        }
    }
    
    @usableFromInline
    func _initializeIfNeeded() throws {
        if bridge.owner == nil {
            bridge.owner = self._dynamicViewGraph
        }
        
        guard bridge.descriptor == nil else {
            return
        }
        
        bridge.descriptor = try _DVViewTypeDescriptor(from: root)
    }
}
