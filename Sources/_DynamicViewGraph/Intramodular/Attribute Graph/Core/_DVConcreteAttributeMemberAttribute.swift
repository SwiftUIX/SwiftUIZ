//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVConcreteAttributeMemberAttribute<BaseValue, Selected: Equatable>: _DVConcreteAttributeModifier {
    public typealias ModifiedValue = Selected

    public struct ModifierKey: Hashable {
        private let keyPath: KeyPath<BaseValue, ModifiedValue>

        fileprivate init(keyPath: KeyPath<BaseValue, ModifiedValue>) {
            self.keyPath = keyPath
        }
    }

    private let keyPath: KeyPath<BaseValue, ModifiedValue>

    internal init(keyPath: KeyPath<BaseValue, ModifiedValue>) {
        self.keyPath = keyPath
    }

    public var key: ModifierKey {
        ModifierKey(keyPath: keyPath)
    }

    public func modify(
        value: BaseValue,
        context: Context
    ) -> ModifiedValue {
        value[keyPath: keyPath]
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

public extension _DVConcreteAttribute {
    func select<Selected: Equatable>(
        _ keyPath: KeyPath<AttributeEvaluator.Value, Selected>
    ) -> _DVModifiedConcreteAttribute<Self, _DVConcreteAttributeMemberAttribute<AttributeEvaluator.Value, Selected>> {
        modifier(_DVConcreteAttributeMemberAttribute(keyPath: keyPath))
    }
}
