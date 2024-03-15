//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public struct _DVConcreteAttributeGraphContext {
    private(set) weak var owner: _DVGraph?
    private(set) weak var graph: _DVConcreteAttributeGraph?
    
    private let overrides: [_DVConcreteAttributeGraph.Override: any _DVScopedOverrideOfConcreteAttribute]
    private let observers: [_DVConcreteAttributeGraphContext.Observer]
    private let enablesAssertion: Bool
    
    @MainActor(unsafe)
    public init(
        _ graph: _DVConcreteAttributeGraph? = nil,
        observers: [_DVConcreteAttributeGraphContext.Observer] = [],
        overrides: [_DVConcreteAttributeGraph.Override: any _DVScopedOverrideOfConcreteAttribute] = [:],
        enablesAssertion: Bool = false
    ) {
        self.owner = graph?.owner
        self.graph = graph
        self.observers = observers
        self.overrides = overrides
        self.enablesAssertion = enablesAssertion
    }
}

extension _DVConcreteAttributeGraphContext {
    public static func createWithScope(
        _ key: _DVConcreteAttributeGraph.Scope,
        store: _DVConcreteAttributeGraph,
        observers: [_DVConcreteAttributeGraphContext.Observer],
        overrides: [_DVConcreteAttributeGraph.Override: any _DVOverrideOfConcreteAttribute]
    ) -> Self {
        _DVConcreteAttributeGraphContext(
            store,
            observers: observers,
            overrides: overrides.mapValues { (override: any _DVOverrideOfConcreteAttribute) in
                override.scoped(key: key)
            },
            enablesAssertion: false
        )
    }
    
    public func scoped(
        key: _DVConcreteAttributeGraph.Scope,
        observers: [_DVConcreteAttributeGraphContext.Observer],
        overrides: [_DVConcreteAttributeGraph.Override: any _DVOverrideOfConcreteAttribute]
    ) -> Self {
        _DVConcreteAttributeGraphContext(
            graph,
            observers: self.observers + observers,
            overrides: self.overrides.merging(
                overrides.lazy.map { ($0, $1.scoped(key: key)) },
                uniquingKeysWith: { $1 }
            ),
            enablesAssertion: enablesAssertion
        )
    }
    
    @available(*, deprecated, renamed: "createWithScope")
    static func scoped(
        key: _DVConcreteAttributeGraph.Scope,
        store: _DVConcreteAttributeGraph,
        observers: [_DVConcreteAttributeGraphContext.Observer],
        overrides: [_DVConcreteAttributeGraph.Override: any _DVOverrideOfConcreteAttribute]
    ) -> Self {
        _DVConcreteAttributeGraphContext(
            store,
            observers: observers,
            overrides: overrides.mapValues { $0.scoped(key: key) },
            enablesAssertion: false
        )
    }
}

extension _DVConcreteAttributeGraphContext {
    public func read<T: _DVConcreteAttribute>(
        _ attribute: T
    ) -> T.AttributeEvaluator.Value {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        
        if let cache = lookupCache(of: attribute, for: key) {
            return cache.value
        } else {
            let cache = makeNewCache(of: attribute, for: key, override: override)
          
            notifyUpdateToObservers()
            
            if checkRelease(for: key) {
                notifyUpdateToObservers()
            }
            
            return cache.value
        }
    }
    
    @usableFromInline
    func set<T: _DVConcreteStateAttribute>(
        _ value: T.AttributeEvaluator.Value,
        for attribute: T
    ) {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        
        if let cache = lookupCache(of: attribute, for: key) {
            update(attribute: attribute, for: key, value: value, cache: cache, order: .newValue)
        }
    }
    
    @usableFromInline
    func modify<Node: _DVConcreteStateAttribute>(_ attribute: Node, body: (inout Node.AttributeEvaluator.Value) -> Void) {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        
        if let cache = lookupCache(of: attribute, for: key) {
            var value = cache.value
            body(&value)
            update(attribute: attribute, for: key, value: value, cache: cache, order: .newValue)
        }
    }
    
    @usableFromInline
    func watch<Node: _DVConcreteAttribute>(_ attribute: Node, in transaction: _DVConcreteAttributeTransaction) -> Node.AttributeEvaluator.Value {
        guard !transaction.isTerminated else {
            return read(attribute)
        }
        
        let store = _getAttributeGraph()
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        let newCache = lookupCache(of: attribute, for: key) ?? makeNewCache(of: attribute, for: key, override: override)
        
        store.structureDescription.dependencies[transaction.key, default: []].insert(key)
        store.structureDescription.children[key, default: []].insert(transaction.key)
        
        return newCache.value
    }
    
    @usableFromInline
    func watch<Node: _DVConcreteAttribute>(
        _ attribute: Node,
        container: _DVConcreteAttributeSubscriptionGroup.Wrapper,
        requiresObjectUpdate: Bool,
        notifyUpdate: @escaping () -> Void
    ) -> Node.AttributeEvaluator.Value {
        let store = _getAttributeGraph()
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        let newCache = lookupCache(of: attribute, for: key) ?? makeNewCache(of: attribute, for: key, override: override)
        let subscription = _DVConcreteAttributeSubscription(
            subscription: container.key,
            location: container.location,
            requiresObjectUpdate: requiresObjectUpdate,
            notifyUpdate: notifyUpdate
        )
        let isNewSubscription = container.subscribers.insert(key).inserted
        
        if let existingSubscription = store.state.subscriptionsByNode[key, default: [:]][container.key] {
            assert(subscription.subscription == existingSubscription.subscription)
        }
        
        store.state.subscriptionsByNode[key, default: [:]].updateValue(subscription, forKey: container.key)
        container.unsubscribe = { keys in
            unsubscribe(keys, for: container.key)
        }
        
        if isNewSubscription {
            notifyUpdateToObservers()
        }
        
        return newCache.value
    }
    
    @usableFromInline
    @_disfavoredOverload
    func refresh<Node: _DVConcreteAttribute>(
        _ attribute: Node
    ) async -> Node.AttributeEvaluator.Value where Node.AttributeEvaluator: _AsyncConcreteAttributeEvaluator {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        let context = prepareTransaction(of: attribute, for: key)
        let value: Node.AttributeEvaluator.Value
        
        if let override {
            value = await attribute._attributeEvaluator.refresh(overridden: override.value(attribute), context: context)
        }
        else {
            value = await attribute._attributeEvaluator.refresh(context: context)
        }
        
        guard let cache = lookupCache(of: attribute, for: key) else {
            // Release the temporarily created state.
            // Do not notify update to observers here because refresh doesn't create a new cache.
            release(for: key)
            return value
        }
        
        // Notify update unless it's cancelled or terminated by other operations.
        if !Task.isCancelled && !context.transaction.isTerminated {
            update(attribute: attribute, for: key, value: value, cache: cache, order: .newValue)
        }
        
        return value
    }
    
    @usableFromInline
    func refresh<Node: _DVRefreshableConcreteAttribute>(_ attribute: Node) async -> Node.AttributeEvaluator.Value {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        let state = getState(of: attribute, for: key)
        let value: Node.AttributeEvaluator.Value
        
        if let override {
            value = override.value(attribute)
        }
        else {
            let context = _DVConcreteAttributeReadWriteAccessContext(store: self, coordinator: state.coordinator)
            value = await attribute.refresh(context: context)
        }
        
        guard let transaction = state.transaction, let cache = lookupCache(of: attribute, for: key) else {
            // Release the temporarily created state.
            // Do not notify update to observers here because refresh doesn't create a new cache.
            release(for: key)
            return value
        }
        
        // Notify update unless it's cancelled or terminated by other operations.
        if !Task.isCancelled && !transaction.isTerminated {
            update(attribute: attribute, for: key, value: value, cache: cache, order: .newValue)
        }
        
        return value
    }
    
    @usableFromInline
    func reset(_ attribute: some _DVConcreteAttribute) {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        
        if let cache = lookupCache(of: attribute, for: key) {
            let newCache = makeNewCache(of: attribute, for: key, override: override)
            update(attribute: attribute, for: key, value: newCache.value, cache: cache, order: .newValue)
        }
    }
    
    @usableFromInline
    func lookup<Node: _DVConcreteAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value? {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        let cache = lookupCache(of: attribute, for: key)
        
        return cache?.value
    }
    
    @usableFromInline
    func unwatch(_ attribute: some _DVConcreteAttribute, container: _DVConcreteAttributeSubscriptionGroup.Wrapper) {
        let override = lookupOverride(of: attribute)
        let key = DVAttributeNodeID(attribute, overrideScopeKey: override?.scope)
        
        container.subscribers.remove(key)
        unsubscribe([key], for: container.key)
    }
    
    @usableFromInline
    func snapshot() -> _DVAttributeGraphSnapshot {
        let store = _getAttributeGraph()
        
        return _DVAttributeGraphSnapshot(
            structureDescription: store.structureDescription,
            caches: store.state.caches,
            subscriptions: store.state.subscriptionsByNode
        )
    }
    
    @usableFromInline
    func restore(_ snapshot: _DVAttributeGraphSnapshot) {
        let store = _getAttributeGraph()
        let keys = ContiguousArray(snapshot.caches.keys)
        var obsoletedDependencies = [DVAttributeNodeID: Set<DVAttributeNodeID>]()
        
        for key in keys {
            let oldDependencies = store.structureDescription.dependencies[key]
            let newDependencies = snapshot.structureDescription.dependencies[key]
            
            // Update attribute values and the graph.
            store.state.caches[key] = snapshot.caches[key]
            store.structureDescription.dependencies[key] = newDependencies
            store.structureDescription.children[key] = snapshot.structureDescription.children[key]
            obsoletedDependencies[key] = oldDependencies?.subtracting(newDependencies ?? [])
        }
        
        for key in keys {
            // Release if the attribute is no longer used.
            checkRelease(for: key)
            
            // Release dependencies that are no longer dependent.
            if let dependencies = obsoletedDependencies[key] {
                for dependency in ContiguousArray(dependencies) {
                    store.structureDescription.children[dependency]?.remove(key)
                    checkRelease(for: dependency)
                }
            }
            
            // Notify updates only for the subscriptions of restored attributes.
            if let subscriptions = store.state.subscriptionsByNode[key] {
                for subscription in ContiguousArray(subscriptions.values) {
                    subscription.notifyUpdate()
                }
            }
        }
        
        notifyUpdateToObservers()
    }
}

extension _DVConcreteAttributeGraphContext {
    func makeNewCache<T: _DVConcreteAttribute>(
        of attribute: T,
        for key: DVAttributeNodeID,
        override: _AnyDVScopedOverrideOfConcreteAttribute<T>?
    ) -> _DVConcreteAttributeCache<T> {
        let store = _getAttributeGraph()
        let context = prepareTransaction(of: attribute, for: key)
        let value: T.AttributeEvaluator.Value
        
        if let override {
            value = attribute._attributeEvaluator.associateOverridden(
                value: override.value(attribute),
                context: context
            )
        }
        else {
            value = attribute._attributeEvaluator.value(context: context)
        }
        
        let cache = _DVConcreteAttributeCache(attribute: attribute, value: value)
      
        store.state.caches[key] = cache
        
        return cache
    }
    
    func prepareTransaction<T: _DVConcreteAttribute>(
        of attribute: T,
        for key: DVAttributeNodeID
    ) -> ConcreteAttributeEvaluationContext<T.AttributeEvaluator.Value, T.AttributeEvaluator.Coordinator> {
        let store = _getAttributeGraph()
        let state = getState(of: attribute, for: key)
        
        // Terminate the ongoing transaction first.
        state.transaction?.terminate()
        
        // Remove current dependencies.
        let oldDependencies = store.structureDescription.dependencies.removeValue(forKey: key) ?? []
        
        // Detatch the attribute from its dependencies.
        for dependency in ContiguousArray(oldDependencies) {
            store.structureDescription.children[dependency]?.remove(key)
        }
        
        let transaction = _DVConcreteAttributeTransaction(key: key) {
            let store = _getAttributeGraph()
            let dependencies = store.structureDescription.dependencies[key] ?? []
            let obsoletedDependencies = oldDependencies.subtracting(dependencies)
            let newDependencies = dependencies.subtracting(oldDependencies)
            
            for dependency in ContiguousArray(obsoletedDependencies) {
                checkRelease(for: dependency)
            }
            
            if !obsoletedDependencies.isEmpty || !newDependencies.isEmpty {
                notifyUpdateToObservers()
            }
        }
        
        // Register the transaction state so it can be terminated from anywhere.
        state.transaction = transaction
        
        return ConcreteAttributeEvaluationContext(
            store: self,
            transaction: transaction,
            coordinator: state.coordinator
        ) { value, order in
            guard let cache = lookupCache(of: attribute, for: key) else {
                return
            }
            
            update(
                attribute: attribute,
                for: key,
                value: value,
                cache: cache,
                order: order
            )
        }
    }
    
    func update<Node: _DVConcreteAttribute>(
        attribute: Node,
        for key: DVAttributeNodeID,
        value: Node.AttributeEvaluator.Value,
        cache: _DVConcreteAttributeCache<Node>,
        order: UpdateOrder
    ) {
        let store = _getAttributeGraph()
        let oldValue = cache.value
        
        if case .newValue = order {
            var cache = cache
            cache.value = value
            store.state.caches[key] = cache
        }
        
        // Do not notify update if the new value and the old value are equivalent.
        if !attribute._attributeEvaluator.shouldUpdate(newValue: value, oldValue: oldValue) {
            return
        }
        
        // Notifying update to view subscriptions first.
        if let subscriptions = store.state.subscriptionsByNode[key] {
            for subscription in ContiguousArray(subscriptions.values) {
                if case .objectWillChange = order, subscription.requiresObjectUpdate {
                    RunLoop.current.perform(subscription.notifyUpdate)
                }
                
                else {
                    subscription.notifyUpdate()
                }
            }
        }
        
        func notifyUpdate() {
            if let children = store.structureDescription.children[key] {
                for child in ContiguousArray(children) {
                    // Reset the attribute value and then notifies downstream attributes.
                    if let cache = store.state.caches[child] {
                        reset(cache.attribute)
                    }
                }
            }
            
            // Notify value update to observers.
            notifyUpdateToObservers()
            
            let state = getState(of: attribute, for: key)
            let context = _DVConcreteAttributeReadWriteAccessContext(store: self, coordinator: state.coordinator)
            attribute.updated(newValue: value, oldValue: oldValue, context: context)
        }
        
        switch order {
            case .newValue:
                notifyUpdate()
                
            case .objectWillChange:
                // At the timing when `ObservableObject/objectWillChange` emits, its properties
                // have not yet been updated and are still old when dependent attributes read it.
                // As a workaround, the update is executed in the next run loop
                // so that the downstream attributes can receive the object that's already updated.
                RunLoop.current.perform {
                    notifyUpdate()
                }
        }
    }
    
    func unsubscribe<Keys: Sequence<DVAttributeNodeID>>(
        _ keys: Keys,
        for subscriptionKey: _DVConcreteAttributeSubscriptionGroup.ID
    ) {
        let store = _getAttributeGraph()
        
        for key in ContiguousArray(keys) {
            store.state.subscriptionsByNode[key]?.removeValue(forKey: subscriptionKey)
            checkRelease(for: key)
        }
        
        notifyUpdateToObservers()
    }
    
    func release(for key: DVAttributeNodeID) {
        // Invalidate transactions, dependencies, and the attribute state.
        let store = _getAttributeGraph()
        let dependencies = store.structureDescription.dependencies.removeValue(forKey: key)
        let state = store.state.states.removeValue(forKey: key)
        store.structureDescription.children.removeValue(forKey: key)
        store.state.caches.removeValue(forKey: key)
        store.state.subscriptionsByNode.removeValue(forKey: key)
        state?.transaction?.terminate()
        
        if let dependencies {
            for dependency in ContiguousArray(dependencies) {
                store.structureDescription.children[dependency]?.remove(key)
                checkRelease(for: dependency)
            }
        }
    }
    
    @discardableResult
    func checkRelease(for key: DVAttributeNodeID) -> Bool {
        let store = _getAttributeGraph()
        
        // The condition under which an attribute may be released are as follows:
        //     1. It's not marked as `KeepAlive` or is overridden.
        //     2. It has no downstream attributes.
        //     3. It has no subscriptions from views.
        lazy var shouldKeepAlive = !key.isOverridden && store.state.caches[key].map { $0.attribute is any KeepAliveAttribute } ?? false
        lazy var isChildrenEmpty = store.structureDescription.children[key]?.isEmpty ?? true
        lazy var isSubscriptionEmpty = store.state.subscriptionsByNode[key]?.isEmpty ?? true
        lazy var shouldRelease = !shouldKeepAlive && isChildrenEmpty && isSubscriptionEmpty
        
        guard shouldRelease else {
            return false
        }
        
        release(for: key)
        return true
    }
    
    func notifyUpdateToObservers() {
        guard !observers.isEmpty else {
            return
        }
        
        let snapshot = snapshot()
        
        for observer in observers {
            observer.onUpdate(snapshot)
        }
    }
    
    public func lookupOverride<Node: _DVConcreteAttribute>(
        of attribute: Node
    ) -> _AnyDVScopedOverrideOfConcreteAttribute<Node>? {
        let baseOverride = overrides[_DVConcreteAttributeGraph.Override(attribute)] ?? overrides[_DVConcreteAttributeGraph.Override(Node.self)]
        
        guard let baseOverride else {
            return nil
        }
        
        guard let override = baseOverride as? _AnyDVScopedOverrideOfConcreteAttribute<Node> else {
            assertionFailure(
                """
                [Attributes]
                Detected an illegal override.
                There might be duplicate keys or logic failure.
                Detected: \(type(of: baseOverride))
                Expected: AttributeScopedOverride<\(Node.self)>
                """
            )
            
            return nil
        }
        
        return override
    }
    
    func getState<Node: _DVConcreteAttribute>(
        of attribute: Node,
        for key: DVAttributeNodeID
    ) -> _AnyDVAttributeNodeTransactionState<Node> {
        let store = _getAttributeGraph()
        
        func makeState() -> _AnyDVAttributeNodeTransactionState<Node> {
            let coordinator = attribute.makeCoordinator()
            let state = _AnyDVAttributeNodeTransactionState<Node>(coordinator: coordinator)
            store.state.states[key] = state
            return state
        }
        
        guard let baseState = store.state.states[key] else {
            return makeState()
        }
        
        guard let state = baseState as? _AnyDVAttributeNodeTransactionState<Node> else {
            assertionFailure(
                """
                [Attributes]
                The type of the given attribute's value and the state did not match.
                There might be duplicate keys, make sure that the keys for all attribute types are unique.
                
                Attribute: \(Node.self)
                Key: \(type(of: attribute.positionHint))
                Detected: \(type(of: baseState))
                Expected: AttributeState<\(Node.Coordinator.self)>
                """
            )
            
            // Release the invalid registration as a fallback.
            release(for: key)
            notifyUpdateToObservers()
            return makeState()
        }
        
        return state
    }
    
    @usableFromInline
    func lookupCache<Node: _DVConcreteAttribute>(
        of attribute: Node,
        for key: DVAttributeNodeID
    ) -> _DVConcreteAttributeCache<Node>? {
        let store = _getAttributeGraph()
        
        guard let baseCache = store.state.caches[key] else {
            return nil
        }
        
        guard let cache = baseCache as? _DVConcreteAttributeCache<Node> else {
            assertionFailure(
                """
                [Attributes]
                The type of the given attribute's value and the cache did not match.
                There might be duplicate keys, make sure that the keys for all attribute types are unique.
                
                Attribute: \(Node.self)
                Key: \(type(of: attribute.positionHint))
                Detected: \(type(of: baseCache))
                Expected: AttributeCache<\(Node.self)>
                """
            )
            
            // Release the invalid registration as a fallback.
            release(for: key)
            notifyUpdateToObservers()
            return nil
        }
        
        return cache
    }
    
    func _getAttributeGraph() -> _DVConcreteAttributeGraph {
        if let store = graph {
            return store
        }
                
        return _DVConcreteAttributeGraph(owner: self.owner!)
    }
}

// MARK: - Auxiliary

extension _DVConcreteAttributeGraphContext {
    @MainActor
    public struct Observer {
        @usableFromInline
        let onUpdate: @MainActor (_DVAttributeGraphSnapshot) -> Void
        
        public init(onUpdate: @escaping (_DVAttributeGraphSnapshot) -> Void) {
            self.onUpdate = onUpdate
        }
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
