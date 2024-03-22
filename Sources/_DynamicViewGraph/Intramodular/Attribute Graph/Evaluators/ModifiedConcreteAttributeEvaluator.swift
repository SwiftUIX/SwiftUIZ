//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct ModifiedConcreteAttributeEvaluator<Node: _DVConcreteAttribute, Modifier: _DVConcreteAttributeModifier>: _DVConcreteAttributeEvaluator where Node.AttributeEvaluator.Value == Modifier.SourceValue {
    public typealias Value = Modifier.ModifiedValue
    public typealias Coordinator = Void
    
    private let attribute: Node
    private let modifier: Modifier
    
    internal init(attribute: Node, modifier: Modifier) {
        self.attribute = attribute
        self.modifier = modifier
    }
    
    public func value(context: Context) -> Value {
        let value = context.withTransactionContext {
            $0.watch(attribute)
        }
        
        return modifier.modify(value: value, context: context.modifierContext)
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        modifier.associateOverridden(value: value, context: context.modifierContext)
    }
    
    public func shouldUpdate(
        newValue: Value,
        oldValue: Value
    ) -> Bool {
        modifier.shouldUpdate(newValue: newValue, oldValue: oldValue)
    }
}

extension ModifiedConcreteAttributeEvaluator: _AsyncConcreteAttributeEvaluator where Node.AttributeEvaluator: _AsyncConcreteAttributeEvaluator, Modifier: _DVConcreteRefreshableAttributeModifier {
    public func refresh(
        context: Context
    ) async -> Value {
        let value = await context.withTransactionContext { context in
            await context.refresh(attribute)
            return context.watch(attribute)
        }
        
        return await modifier.refresh(
            modifying: value,
            context: context.modifierContext
        )
    }
    
    public func refresh(
        overridden value: Value,
        context: Context
    ) async -> Value {
        await modifier.refresh(overridden: value, context: context.modifierContext)
    }
}
