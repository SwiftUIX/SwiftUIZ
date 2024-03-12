//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DVConcreteAttributeModifier {
    associatedtype ModifierKey: Hashable
    associatedtype SourceValue
    associatedtype ModifiedValue
    
    typealias Context = _DVModifiedConcreteAttributeAccessContext<ModifiedValue>
    
    var key: ModifierKey { get }
    
    @MainActor
    func modify(value: SourceValue, context: Context) -> ModifiedValue
    @MainActor
    func associateOverridden(value: ModifiedValue, context: Context) -> ModifiedValue
    @MainActor
    func shouldUpdate(newValue: ModifiedValue, oldValue: ModifiedValue) -> Bool
}

public extension _DVConcreteAttributeModifier {
    func shouldUpdate(newValue: ModifiedValue, oldValue: ModifiedValue) -> Bool {
        true
    }
}

public protocol _DVConcreteRefreshableAttributeModifier: _DVConcreteAttributeModifier {
    @MainActor
    func refresh(
        modifying value: SourceValue,
        context: Context
    ) async -> ModifiedValue

    @MainActor
    func refresh(
        overridden value: ModifiedValue,
        context: Context
    ) async -> ModifiedValue
}

extension _DVConcreteAttribute {
    public func modifier<T: _DVConcreteAttributeModifier>(_ modifier: T) -> _DVModifiedConcreteAttribute<Self, T> {
        _DVModifiedConcreteAttribute(attribute: self, modifier: modifier)
    }
}
