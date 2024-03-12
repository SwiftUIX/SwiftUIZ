//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public protocol _DVConcreteAttributeEvaluator {
    associatedtype Value
    associatedtype Coordinator
    
    typealias Context = ConcreteAttributeEvaluationContext<Value, Coordinator>
    
    func value(context: Context) -> Value
    func associateOverridden(value: Value, context: Context) -> Value
    func shouldUpdate(newValue: Value, oldValue: Value) -> Bool
}

public protocol _AsyncConcreteAttributeEvaluator: _DVConcreteAttributeEvaluator {
    func refresh(context: Context) async -> Value
    func refresh(overridden value: Value, context: Context) async -> Value
}

public protocol AsyncConcreteAttributeEvaluator: _AsyncConcreteAttributeEvaluator where Value == Task<Success, Failure> {
    associatedtype Success
    associatedtype Failure: Error
}

public extension _DVConcreteAttributeEvaluator {
    func shouldUpdate(newValue: Value, oldValue: Value) -> Bool {
        true
    }
}
