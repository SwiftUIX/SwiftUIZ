//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public protocol _DVConcreteAttributeAccessContextType {
    func read<T: _DVConcreteAttribute>(
        _: T
    ) -> T.AttributeEvaluator.Value
    
    func set<T: _DVConcreteStateAttribute>(
        _: T.AttributeEvaluator.Value,
        for _: T
    )
    
    func modify<T: _DVConcreteStateAttribute>(
        _ attribute: T,
        body: (inout T.AttributeEvaluator.Value) -> Void
    )
    
    @_disfavoredOverload
    @discardableResult
    func refresh<T: _DVConcreteAttribute>(
        _: T
    ) async -> T.AttributeEvaluator.Value where T.AttributeEvaluator: _AsyncConcreteAttributeEvaluator
  
    @discardableResult
    func refresh<T: _DVRefreshableConcreteAttribute>(
        _: T
    ) async -> T.AttributeEvaluator.Value
   
    func reset(
        _: some _DVConcreteAttribute
    )
}

public extension _DVConcreteAttributeAccessContextType {
    subscript<Node: _DVConcreteStateAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value {
        get {
            read(attribute)
        } nonmutating set {
            set(newValue, for: attribute)
        }
    }
}

@MainActor
public protocol _DVConcreteAttributeAccessObserveContext: _DVConcreteAttributeAccessContextType {
    @discardableResult
    func watch<Node: _DVConcreteAttribute>(
        _ attribute: Node
    ) -> Node.AttributeEvaluator.Value
}

public extension _DVConcreteAttributeAccessObserveContext {
    @inlinable
    func state<Node: _DVConcreteStateAttribute>(_ attribute: Node) -> Binding<Node.AttributeEvaluator.Value> {
        Binding(
            get: { watch(attribute) },
            set: { self[attribute] = $0 }
        )
    }
}
