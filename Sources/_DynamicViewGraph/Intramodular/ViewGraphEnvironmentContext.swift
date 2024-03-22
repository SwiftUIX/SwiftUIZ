//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct ViewGraphEnvironmentContext {
    public weak var graph: ViewGraph?

    public var inheritance: [ViewGraph.Node.ID] = []
    
    public var inheritedNodes: [ViewGraph.Node] {
        guard let graph else {            
            return []
        }
        
        precondition(!graph._isInvalidInstance)
        
        return inheritance.map({ graph[$0] })
    }
    
    public var attributeGraphScope = _DVConcreteAttributeGraph.Scope()
    public var attributeGraphOverrides = [_DVConcreteAttributeGraph.Override: any _DVOverrideOfConcreteAttribute]()
    public var attributeGraphObservers = [_DVConcreteAttributeGraphContext.Observer]()
    
    public init(graph: ViewGraph?) {
        self.graph = graph
    }
    
    public func insert(
        override x: some _DVConcreteAttribute,
        withIdentifier id: DVAttributeNodeID
    ) {
        attributeGraphOverrides[.init(attribute: x)]
    }
}

extension ViewGraphEnvironmentContext: MergeOperatable {
    public mutating func mergeInPlace(
        with other: ViewGraphEnvironmentContext
    ) {
        self.attributeGraphOverrides._unsafelyMerge(other.attributeGraphOverrides)
        self.attributeGraphObservers.append(contentsOf: other.attributeGraphObservers)
    }
}

extension ViewGraphEnvironmentContext {
    struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static let defaultValue = ViewGraphEnvironmentContext(graph: nil)
    }
}

extension EnvironmentValues {
    @MainActor
    public var _dynamicViewGraphContext: ViewGraphEnvironmentContext {
        get {
            self[ViewGraphEnvironmentContext.EnvironmentKey.self]
        } set {
            self[ViewGraphEnvironmentContext.EnvironmentKey.self] = newValue
        }
    }
    
    @MainActor
    public var _dynamicViewAttributeGraphContext: _DVConcreteAttributeGraphContext {
        get {
            _DVConcreteAttributeGraphContext(from: self)
        }
    }
}
