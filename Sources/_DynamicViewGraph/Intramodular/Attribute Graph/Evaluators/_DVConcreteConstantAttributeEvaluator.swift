//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVConcreteConstantAttributeEvaluator<T: _DVConcreteConstantAttribute>: _DVConcreteAttributeEvaluator {
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
        context.withTransactionContext(attribute.value)
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        value
    }
}
