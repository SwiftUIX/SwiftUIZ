//
// Copyright (c) Vatsal Manot
//

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
    
    public init() {
        _isInvalidInstance = false
        
        _ = self
        
        Self.allCases.insert(self)
    }
}

extension _DVGraph {
    public struct NodeTypeKind {
        
    }
    
    public struct NodeTypeMetadata {
        
    }
    
    public class Node: CustomStringConvertible, Identifiable {
        public let id = _AutoIncrementingIdentifier<_DVGraph.Node>()
        
        public var description: String {
            "#\(id)"
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

extension _DVConcreteAttributeGraphContext {
    public init(from environment: EnvironmentValues) {
        let graph = environment._dynamicViewGraph
        
        self = .createWithScope(
            environment._dynamicViewGraphContext.attributeGraphScope,
            store: graph.concreteAttributeGraph,
            observers: environment._dynamicViewGraphContext.attributeGraphObservers,
            overrides: environment._dynamicViewGraphContext.attributeGraphOverrides
        )
    }
}

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
