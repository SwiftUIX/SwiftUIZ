//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

public protocol _DVConcreteAsyncSequenceAttribute: _DVConcreteAttribute {
    associatedtype Sequence: AsyncSequence

    @MainActor
    func sequence(context: Context) -> Sequence
}

public extension _DVConcreteAsyncSequenceAttribute {
    @MainActor
    var _attributeEvaluator: AsyncSequenceConcreteAttributeEvaluator<Self> {
        AsyncSequenceConcreteAttributeEvaluator(attribute: self)
    }
}

public struct AsyncSequenceConcreteAttributeEvaluator<Node: _DVConcreteAsyncSequenceAttribute>: _AsyncConcreteAttributeEvaluator {
    public typealias Value = AsyncPhase<Node.Sequence.Element, Error>
    public typealias Coordinator = Node.Coordinator
    
    private let attribute: Node
    
    internal init(attribute: Node) {
        self.attribute = attribute
    }
    
    public func value(
        context: Context
    ) -> Value {
        let sequence = context.withTransactionContext(attribute.sequence)
        let task = Task {
            do {
                for try await element in sequence {
                    if !Task.isCancelled {
                        context.update(with: .success(element), order: .newValue)
                    }
                }
            }
            catch {
                if !Task.isCancelled {
                    context.update(with: .failure(error), order: .newValue)
                }
            }
        }
        
        context.addTermination(task.cancel)
        
        return .suspending
    }
    
    public func associateOverridden(value: Value, context: Context) -> Value {
        value
    }
    
    public func refresh(
        context: Context
    ) async -> Value {
        let sequence = context.withTransactionContext(attribute.sequence)
        let task = Task {
            var phase = Value.suspending
            
            do {
                for try await element in sequence {
                    if !Task.isCancelled {
                        phase = .success(element)
                    }
                }
            }
            catch {
                phase = .failure(error)
            }
            
            return phase
        }
        
        context.addTermination(task.cancel)
        
        return await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
    }
    
    public func refresh(
        overridden value: Value,
        context: Context
    ) async -> Value {
        value
    }
}
