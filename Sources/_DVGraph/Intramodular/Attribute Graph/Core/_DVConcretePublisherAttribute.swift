//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

public protocol _DVConcretePublisherAttribute: _DVConcreteAttribute {
    associatedtype Publisher: Combine.Publisher

    @MainActor
    func publisher(context: Context) -> Publisher
}

public extension _DVConcretePublisherAttribute {
    @MainActor
    var _attributeEvaluator: _DVPublisherConcreteAttributeEvaluator<Self> {
        _DVPublisherConcreteAttributeEvaluator(attribute: self)
    }
}

public struct _DVPublisherConcreteAttributeEvaluator<T: _DVConcretePublisherAttribute>: _AsyncConcreteAttributeEvaluator {
    public typealias Value = AsyncPhase<T.Publisher.Output, T.Publisher.Failure>
    
    public typealias Coordinator = T.Coordinator
    
    private let attribute: T
    
    internal init(attribute: T) {
        self.attribute = attribute
    }
    
    public func value(context: Context) -> Value {
        let results = context.withTransactionContext(attribute.publisher).results
        let task = Task {
            for await result in results {
                if !Task.isCancelled {
                    context.update(with: AsyncPhase(result), order: .newValue)
                }
            }
        }
        
        context.addTermination(task.cancel)
        
        return .suspending
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        value
    }
    
    public func refresh(
        context: Context
    ) async -> Value {
        let results = context.withTransactionContext(attribute.publisher).results
        let task = Task {
            var phase = Value.suspending
            
            for await result in results {
                if !Task.isCancelled {
                    phase = AsyncPhase(result)
                }
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

private extension Publisher {
    var results: AsyncStream<Result<Output, Failure>> {
        AsyncStream { continuation in
            let cancellable = map(Result.success)
                .catch { Just(.failure($0)) }
                .sink(
                    receiveCompletion: { _ in
                        continuation.finish()
                    },
                    receiveValue: { result in
                        continuation.yield(result)
                    }
                )
            
            continuation.onTermination = { termination in
                switch termination {
                    case .cancelled:
                        cancellable.cancel()
                        
                    case .finished:
                        break
                        
                    @unknown default:
                        break
                }
            }
        }
    }
}
