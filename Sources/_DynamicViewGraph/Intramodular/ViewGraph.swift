//
// Copyright (c) Vatsal Manot
//

import Compute
import Merge
import Swallow
import SwiftUIX

extension ViewGraph {
    public private(set) static var allCases = _WeakSet<ViewGraph>()
}

public final class ViewGraph: ObservableObject {
    public let _isInvalidInstance: Bool
    
    @MainActor(unsafe)
    lazy var concreteAttributeGraph = _DVConcreteAttributeGraph(owner: self)
    
    public var nodes: IdentifierIndexingArrayOf<Node> = []

    public init(invalid: ()) {
        self._isInvalidInstance = true
    }
    
    public subscript(_ id: Node.ID) -> Node {
        nodes[id: id]!
    }
    
    public func insert(_ node: Node) {
        self.nodes.insert(node)
    }
    
    public func remove(_ node: Node) {
        self.nodes.remove(node)
    }
        
    public init() {
        _isInvalidInstance = false
        
        _ = self
        
        Self.allCases.insert(self)
    }
    
    public func lookupOverride(for node: Node) {
        
    }
}

public struct _DVViewDescriptor {
    
}

extension ViewGraph {
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

extension ViewGraph.Node {
    public struct AssociatedItemID: Hashable {
        public let base: _AnyIdentifiableIdentifier
        
        public init(from x: any ViewGraphParticipant) {
            self.base = _AnyIdentifiableIdentifier(from: x)
        }
    }
    
}

extension ViewGraph {
    public func materializeContent(for node: ViewGraph.Node) -> any View {
        fatalError()
    }
}

// MARK: - Internal

extension ViewGraph {
    public struct _GraphTypeDefinition: _StaticGraphTypeDefinition {
        public typealias Node = ViewGraph.Node
        public typealias Edge = ViewGraph.Edge
    }
}

extension ViewGraph.Node: _StaticGraphNodeDefinition {
    public typealias Value = ViewGraph.Node
}

// MARK: - SwiftUI

extension ViewGraph {
    fileprivate struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static var defaultValue: ViewGraph {
            ViewGraph(invalid: ())
        }
    }
}

extension EnvironmentValues {
    public var _dynamicViewGraph: ViewGraph {
        get {
            self[ViewGraph.EnvironmentKey.self]
        } set {
            self[ViewGraph.EnvironmentKey.self] = newValue
        }
    }
}
