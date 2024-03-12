//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public struct _DVConcreteAttributeTransactionalAccessContext<Coordinator>: _DVConcreteAttributeAccessObserveContext {
    @usableFromInline
    internal let _store: _DVConcreteAttributeGraphContext
    @usableFromInline
    internal let _transaction: _DVConcreteAttributeTransaction

    public let coordinator: Coordinator

    internal init(
        store: _DVConcreteAttributeGraphContext,
        transaction: _DVConcreteAttributeTransaction,
        coordinator: Coordinator
    ) {
        self._store = store
        self._transaction = transaction
        self.coordinator = coordinator
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

    @inlinable
    @discardableResult
    public func watch<Node: _DVConcreteAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value {
        _store.watch(attribute, in: _transaction)
    }
}
