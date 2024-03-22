//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

public protocol _DVConcreteObservableObjectAttribute: _DVConcreteAttribute {
    associatedtype ObjectType: ObservableObject
        
    @MainActor
    func object(context: Context) -> ObjectType
}

public extension _DVConcreteObservableObjectAttribute {
    @MainActor
    var _attributeEvaluator: ObservableObjectConcreteAttributeEvaluator<Self> {
        ObservableObjectConcreteAttributeEvaluator(attribute: self)
    }
}

public struct ObservableObjectConcreteAttributeEvaluator<T: _DVConcreteObservableObjectAttribute>: _DVConcreteAttributeEvaluator {
    public typealias Value = T.ObjectType
    public typealias Coordinator = T.Coordinator
    
    private let attribute: T
    
    internal init(attribute: T) {
        self.attribute = attribute
    }
    
    public func value(
        context: Context
    ) -> Value {
        let object = context.withTransactionContext(attribute.object(context:))
        
        return associateOverridden(
            value: object,
            context: context
        )
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        let cancellable = value.objectWillChange.sink { [weak value] _ in
            guard let value else {
                return
            }
            
            context.update(with: value, order: .objectWillChange)
        }
        
        context.addTermination(cancellable.cancel)
        
        return value
    }
}
