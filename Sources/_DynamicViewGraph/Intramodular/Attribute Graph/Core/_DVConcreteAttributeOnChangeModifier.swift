//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVConcreteAttributeOnChangeModifier<T: Equatable>: _DVConcreteAttributeModifier {
    public typealias SourceValue = T
    public typealias ModifiedValue = T

    public struct ModifierKey: Hashable {
        
    }

    public var key: ModifierKey {
        ModifierKey()
    }

    public func modify(
        value: SourceValue,
        context: Context
    ) -> ModifiedValue {
        value
    }

    public func associateOverridden(
        value: ModifiedValue,
        context: Context
    ) -> ModifiedValue {
        value
    }

    public func shouldUpdate(
        newValue: ModifiedValue,
        oldValue: ModifiedValue
    ) -> Bool {
        newValue != oldValue
    }
}

public extension _DVConcreteAttribute where AttributeEvaluator.Value: Equatable {
    var changes: _DVModifiedConcreteAttribute<Self, _DVConcreteAttributeOnChangeModifier<AttributeEvaluator.Value>> {
        modifier(_DVConcreteAttributeOnChangeModifier())
    }
}
