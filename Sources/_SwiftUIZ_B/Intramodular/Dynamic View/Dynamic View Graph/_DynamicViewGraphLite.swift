//
// Copyright (c) Vatsal Manot
//

import Compute
import Merge
import Swallow
import SwiftUIX
import _SwiftUIZ_A

@objc(_SwiftUIZ_DynamicViewGraphLite)
public final class _DynamicViewGraphLite: _AnyDynamicViewGraph, _DynamicViewGraphType {
    package var baseDescriptors: IdentifierIndexingArrayOf<_StaticViewTypeDescriptor> = []
    package var nodes: IdentifierIndexingArray<any _DynamicViewGraphNodeType, _ViewGraphNodeID> = .init(id: \._opaque_id)
        
    public subscript(_ id: Node.ID) -> any _DynamicViewGraphNodeType {
        nodes[id: id]!
    }
    
    public func insert(_ node: any _DynamicViewGraphNodeType) {
        self.nodes.insert(node)
    }
    
    public func prepare(_ node: some _DynamicViewGraphNodeType) throws {
        
    }
    
    public func remove(_ node: any _DynamicViewGraphNodeType) {
        self.nodes.remove(node)
    }
}

// MARK: - Internal

extension _DynamicViewGraphLite {
    public class Edge: HashEquatable {
        public let source: Node
        public let destination: Node
        
        public init(source: Node, destination: Node) {
            self.source = source
            self.destination = destination
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(source)
            hasher.combine(destination)
        }
    }
}
