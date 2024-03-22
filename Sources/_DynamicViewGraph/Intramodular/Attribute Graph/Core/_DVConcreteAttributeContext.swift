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
    public func read<T: _DVConcreteAttribute>(
        _ attribute: T
    ) -> T.AttributeEvaluator.Value {
        _store.read(attribute)
    }

    @inlinable
    public func set<T: _DVConcreteStateAttribute>(
        _ value: T.AttributeEvaluator.Value,
        for attribute: T
    ) {
        _store.set(value, for: attribute)
    }

    @inlinable
    public func modify<T: _DVConcreteStateAttribute>(
        _ attribute: T,
        body: (inout T.AttributeEvaluator.Value) -> Void
    ) {
        _store.modify(attribute, body: body)
    }

    @inlinable
    @_disfavoredOverload
    @discardableResult
    public func refresh<T: _DVConcreteAttribute>(
        _ attribute: T
    ) async -> T.AttributeEvaluator.Value where T.AttributeEvaluator: _AsyncConcreteAttributeEvaluator {
        await _store.refresh(attribute)
    }

    @inlinable
    @discardableResult
    public func refresh<T: _DVRefreshableConcreteAttribute>(
        _ attribute: T
    ) async -> T.AttributeEvaluator.Value {
        await _store.refresh(attribute)
    }

    @inlinable
    public func reset(
        _ attribute: some _DVConcreteAttribute
    ) {
        _store.reset(attribute)
    }

    @discardableResult
    @inlinable
    public func watch<T: _DVConcreteAttribute>(
        _ attribute: T
    ) -> T.AttributeEvaluator.Value {
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
