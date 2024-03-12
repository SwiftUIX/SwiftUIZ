//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DVConcreteTaskAttribute: _DVConcreteAttribute {
    associatedtype Value

    @MainActor
    func value(context: Context) async -> Value
}

public extension _DVConcreteTaskAttribute {
    @MainActor
    var _attributeEvaluator: _DVConcreteTaskAttributeEvaluator<Self> {
        _DVConcreteTaskAttributeEvaluator(attribute: self)
    }
}

public struct _DVConcreteTaskAttributeEvaluator<T: _DVConcreteTaskAttribute>: AsyncConcreteAttributeEvaluator {
    public typealias Success = T.Value
    public typealias Failure = Never
    public typealias Value = Task<Success, Failure>
    public typealias Coordinator = T.Coordinator
    
    private let attribute: T
    
    internal init(attribute: T) {
        self.attribute = attribute
    }
    
    public func value(context: Context) -> Task<Success, Failure> {
        let task = Task {
            await context.withTransactionContext(attribute.value)
        }
        return associateOverridden(value: task, context: context)
    }
    
    public func associateOverridden(
        value: Task<Success, Failure>,
        context: Context
    ) -> Value {
        context.addTermination {
            value.cancel()
        }
        return value
    }
    
    public func refresh(
        context: Context
    ) async -> Value {
        let task = Task {
            await context.withTransactionContext(attribute.value)
        }
        return await refresh(overridden: task, context: context)
    }
    
    public func refresh(
        overridden value: Task<Success, Failure>,
        context: Context
    ) async -> Value {
        context.addTermination(value.cancel)
        
        return await withTaskCancellationHandler {
            _ = await value.result
            return value
        } onCancel: {
            value.cancel()
        }
    }
}
