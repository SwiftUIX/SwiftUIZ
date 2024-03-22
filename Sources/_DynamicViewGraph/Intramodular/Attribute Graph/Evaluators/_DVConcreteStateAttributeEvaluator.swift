//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVConcreteStateAttributeEvaluator<T: _DVConcreteStateAttribute>: _DVConcreteAttributeEvaluator {
    public typealias Value = T.Value
    public typealias Coordinator = T.Coordinator
    
    private let attribute: T
    
    internal init(
        attribute: T
    ) {
        self.attribute = attribute
    }
    
    public func value(
        context: Context
    ) -> Value {
        context.withTransactionContext(attribute.defaultValue)
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        value
    }
}
