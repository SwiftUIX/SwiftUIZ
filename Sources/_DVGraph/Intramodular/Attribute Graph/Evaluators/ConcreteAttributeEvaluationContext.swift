//
// Copyright (c) Vatsal Manot
//

import SwiftUI

internal enum UpdateOrder {
    case newValue
    case objectWillChange
}

@MainActor
public struct ConcreteAttributeEvaluationContext<Value, Coordinator> {
    internal let store: _DVConcreteAttributeGraphContext
    internal let transaction: _DVConcreteAttributeTransaction
    internal let coordinator: Coordinator
    internal let update: @MainActor (Value, UpdateOrder) -> Void
    
    internal init(
        store: _DVConcreteAttributeGraphContext,
        transaction: _DVConcreteAttributeTransaction,
        coordinator: Coordinator,
        update: @escaping @MainActor (Value, UpdateOrder) -> Void
    ) {
        self.store = store
        self.transaction = transaction
        self.coordinator = coordinator
        self.update = update
    }
    
    internal var modifierContext: _DVModifiedConcreteAttributeAccessContext<Value> {
        _DVModifiedConcreteAttributeAccessContext(transaction: transaction) { value in
            update(with: value, order: .newValue)
        }
    }
    
    internal func update(
        with value: Value,
        order: UpdateOrder = .newValue
    ) {
        update(value, order)
    }
    
    internal func addTermination(
        _ termination: @MainActor @escaping () -> Void
    ) {
        transaction.addTerminationHandler(termination)
    }
    
    internal func withTransactionContext<T>(
        _ body: @MainActor (_DVConcreteAttributeTransactionalAccessContext<Coordinator>) -> T
    ) -> T {
        let context = _DVConcreteAttributeTransactionalAccessContext(
            store: store,
            transaction: transaction,
            coordinator: coordinator
        )
        defer {
            transaction.commit()
        }
        return body(context)
    }
    
    internal func withTransactionContext<T>(
        _ body: @MainActor (_DVConcreteAttributeTransactionalAccessContext<Coordinator>) async throws -> T
    ) async rethrows -> T {
        let context = _DVConcreteAttributeTransactionalAccessContext(
            store: store,
            transaction: transaction,
            coordinator: coordinator
        )
        
        defer {
            transaction.commit()
        }
        
        return try await body(context)
    }
}
