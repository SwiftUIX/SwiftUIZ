//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public struct _DVConcreteAttributeContext: _DVConcreteAttributeAccessObserveContext {
    public let _store: _DVConcreteAttributeGraphContext

    @usableFromInline
    internal let _container: _DVConcreteAttributeSubscriptionGroup.Wrapper
    @usableFromInline
    internal let _notifyUpdate: () -> Void

    public init(
        store: _DVConcreteAttributeGraphContext,
        container: _DVConcreteAttributeSubscriptionGroup.Wrapper,
        notifyUpdate: @escaping () -> Void
    ) {
        _store = store
        _container = container
        _notifyUpdate = notifyUpdate
    }

    @inlinable
    public func read<Node: _DVConcreteAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value {
        _store.read(attribute)
    }

    @inlinable
    public func set<Node: _DVConcreteStateAttribute>(_ value: Node.AttributeEvaluator.Value, for attribute: Node) {
        _store.set(value, for: attribute)
    }

    @inlinable
    public func modify<Node: _DVConcreteStateAttribute>(_ attribute: Node, body: (inout Node.AttributeEvaluator.Value) -> Void) {
        _store.modify(attribute, body: body)
    }

    @inlinable
    @_disfavoredOverload
    @discardableResult
    public func refresh<Node: _DVConcreteAttribute>(_ attribute: Node) async -> Node.AttributeEvaluator.Value where Node.AttributeEvaluator: _AsyncConcreteAttributeEvaluator {
        await _store.refresh(attribute)
    }

    @inlinable
    @discardableResult
    public func refresh<Node: _DVRefreshableConcreteAttribute>(_ attribute: Node) async -> Node.AttributeEvaluator.Value {
        await _store.refresh(attribute)
    }

    @inlinable
    public func reset(_ attribute: some _DVConcreteAttribute) {
        _store.reset(attribute)
    }

    @discardableResult
    @inlinable
    public func watch<Node: _DVConcreteAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value {
        _store.watch(
            attribute,
            container: _container,
            requiresObjectUpdate: false,
            notifyUpdate: _notifyUpdate
        )
    }

    @discardableResult
    @inlinable
    public func snapshot() -> _DVAttributeGraphSnapshot {
        _store.snapshot()
    }

    @inlinable
    public func restore(_ snapshot: _DVAttributeGraphSnapshot) {
        _store.restore(snapshot)
    }
}
