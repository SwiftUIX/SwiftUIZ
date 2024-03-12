//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DVConcreteThrowingTaskAttribute: _DVConcreteAttribute {
    associatedtype Value

    @MainActor
    func value(context: Context) async throws -> Value
}

public extension _DVConcreteThrowingTaskAttribute {
    @MainActor
    var _attributeEvaluator: ThrowingTaskConcreteAttributeEvaluator<Self> {
        ThrowingTaskConcreteAttributeEvaluator(attribute: self)
    }
}

public struct ThrowingTaskConcreteAttributeEvaluator<T: _DVConcreteThrowingTaskAttribute>: AsyncConcreteAttributeEvaluator {
    public typealias Success = T.Value
    public typealias Failure = Error
    public typealias Value = Task<Success, Failure>
    public typealias Coordinator = T.Coordinator
    
    private let attribute: T
    
    internal init(attribute: T) {
        self.attribute = attribute
    }
    
    public func value(
        context: Context
    ) -> Value {
        let task = Task {
            try await context.withTransactionContext(attribute.value)
        }
        
        return associateOverridden(value: task, context: context)
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        context.addTermination(value.cancel)
        
        return value
    }
    
    public func refresh(
        context: Context
    ) async -> Value {
        let task = Task {
            try await context.withTransactionContext(attribute.value)
        }
        return await refresh(overridden: task, context: context)
    }
    
    public func refresh(
        overridden value: Value,
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
