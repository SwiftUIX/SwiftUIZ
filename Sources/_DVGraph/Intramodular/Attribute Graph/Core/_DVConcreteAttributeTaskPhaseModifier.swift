//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVConcreteAttributeTaskPhaseModifier<Success, Failure: Error>: _DVConcreteRefreshableAttributeModifier {
    public typealias SourceValue = Task<Success, Failure>
    public typealias ModifiedValue = AsyncPhase<Success, Failure>
    
    public struct ModifierKey: Hashable {}
    
    public var key: ModifierKey {
        ModifierKey()
    }
    
    public func modify(
        value: SourceValue,
        context: Context
    ) -> ModifiedValue {
        let task = Task {
            let phase = await AsyncPhase(value.result)
            
            if !Task.isCancelled {
                context.update(with: phase)
            }
        }
        
        context.addTermination(task.cancel)
        
        return .suspending
    }
    
    public func associateOverridden(
        value: ModifiedValue,
        context: Context
    ) -> ModifiedValue {
        value
    }
    
    public func refresh(
        modifying value: SourceValue,
        context: Context
    ) async -> ModifiedValue {
        context.addTermination(value.cancel)
        
        return await withTaskCancellationHandler {
            await AsyncPhase(value.result)
        } onCancel: {
            value.cancel()
        }
    }
    
    public func refresh(
        overridden value: ModifiedValue,
        context: Context
    ) async -> ModifiedValue {
        value
    }
}

extension _DVConcreteAttribute where AttributeEvaluator: AsyncConcreteAttributeEvaluator {
    var phase: _DVModifiedConcreteAttribute<Self, _DVConcreteAttributeTaskPhaseModifier<AttributeEvaluator.Success, AttributeEvaluator.Failure>> {
        modifier(_DVConcreteAttributeTaskPhaseModifier())
    }
}
