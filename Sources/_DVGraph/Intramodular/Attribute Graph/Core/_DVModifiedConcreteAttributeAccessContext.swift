//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public struct _DVModifiedConcreteAttributeAccessContext<Value> {
    internal let _transaction: _DVConcreteAttributeTransaction
    internal let _update: @MainActor (Value) -> Void
    
    internal init(
        transaction: _DVConcreteAttributeTransaction,
        update: @escaping @MainActor (Value) -> Void
    ) {
        _transaction = transaction
        _update = update
    }
    
    public func update(with value: Value) {
        _update(value)
    }
    
    public func addTermination(_ termination: @MainActor @escaping () -> Void) {
        _transaction.addTerminationHandler(termination)
    }
}
