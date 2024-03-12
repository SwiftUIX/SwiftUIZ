//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DVOverrideOfConcreteAttribute {
    associatedtype AttributeType: _DVConcreteAttribute
    
    var value: (AttributeType) -> AttributeType.AttributeEvaluator.Value { get }
    
    func scoped(
        key: _DVConcreteAttributeGraph.Scope
    ) -> any _DVScopedOverrideOfConcreteAttribute
}

public protocol _DVScopedOverrideOfConcreteAttribute {
    var scope: _DVConcreteAttributeGraph.Scope { get }
}

public struct _AnyDVScopedOverrideOfConcreteAttribute<T: _DVConcreteAttribute>: _DVScopedOverrideOfConcreteAttribute {
    public let scope: _DVConcreteAttributeGraph.Scope
    public let value: (T) -> T.AttributeEvaluator.Value
    
    public init(
        scope: _DVConcreteAttributeGraph.Scope,
        value: @escaping (T) -> T.AttributeEvaluator.Value
    ) {
        self.scope = scope
        self.value = value
    }
}

public struct AttributeOverride<T: _DVConcreteAttribute>: _DVOverrideOfConcreteAttribute {
    public let value: (T) -> T.AttributeEvaluator.Value
    
    @inlinable
    public init(value: @escaping (T) -> T.AttributeEvaluator.Value) {
        self.value = value
    }
    
    @inlinable
    public func scoped(key: _DVConcreteAttributeGraph.Scope) -> any _DVScopedOverrideOfConcreteAttribute {
        _AnyDVScopedOverrideOfConcreteAttribute<T>(scope: key, value: value)
    }
}
