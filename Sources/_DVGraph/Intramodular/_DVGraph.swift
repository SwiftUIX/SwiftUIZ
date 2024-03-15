//
// Copyright (c) Vatsal Manot
//

import Compute
import Merge
import Swallow
import SwiftUIX

extension _DVGraph {
    public private(set) static var allCases = _WeakSet<_DVGraph>()
}

public final class _DVGraph: ObservableObject {
    public let _isInvalidInstance: Bool
    
    @MainActor(unsafe)
    lazy var concreteAttributeGraph = _DVConcreteAttributeGraph(owner: self)
    
    public var nodes: IdentifierIndexingArrayOf<Node> = []
    
    public init(invalid: ()) {
        self._isInvalidInstance = true
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
}

public struct _DVViewDescriptor {
    
}

extension _DVGraph {
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

extension _DVGraph {
    public class Node: CustomStringConvertible, HashEquatable, Identifiable {
        public let id = _AutoIncrementingIdentifier<_DVGraph.Node>()
        
        public var attributes: [DVAttributeNodeID: any _DVConcreteAttribute] = [:]
        
        public var description: String {
            "#\(id)"
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        public init() {
            
        }
    }
}

extension _DVGraph {
    public func materializeContent(for node: _DVGraph.Node) -> any View {
        fatalError()
    }
}

// MARK: - Internal

extension _DVGraph {
    public struct _GraphTypeDefinition: _StaticGraphTypeDefinition {
        public typealias Node = _DVGraph.Node
        public typealias Edge = _DVGraph.Edge
    }
}

extension _DVGraph.Node: _StaticGraphNodeDefinition {
    public typealias Value = _DVGraph.Node
}

// MARK: - SwiftUI

extension _DVGraph {
    fileprivate struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static var defaultValue: _DVGraph {
            _DVGraph(invalid: ())
        }
    }
}

extension EnvironmentValues {
    public var _dynamicViewGraph: _DVGraph {
        get {
            self[_DVGraph.EnvironmentKey.self]
        } set {
            self[_DVGraph.EnvironmentKey.self] = newValue
        }
    }
}
