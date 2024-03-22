//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import SwiftUI

public final class ViewGraphMembership: ObservableObject {
    weak var graph: ViewGraph?
    
    public var node: ViewGraph.Node
    
    public init(
        graph: ViewGraph,
        bridge: _DynamicViewBridge
    ) {
        self.graph = graph
        self.node = ViewGraph.Node(graph: graph, typeDescriptor: bridge.descriptor)
        
        graph.insert(node)
    }
    
    deinit {
        graph?.remove(node)
    }
}
