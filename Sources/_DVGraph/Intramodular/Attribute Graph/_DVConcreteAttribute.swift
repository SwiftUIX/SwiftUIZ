//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public protocol _DVConcreteAttribute {
    associatedtype PositionHint: Hashable
    associatedtype AttributeEvaluator: _DVConcreteAttributeEvaluator where AttributeEvaluator.Coordinator == Coordinator
    associatedtype Coordinator = Void
    
    typealias Context = _DVConcreteAttributeTransactionalAccessContext<Coordinator>
    typealias UpdatedContext = _DVConcreteAttributeReadWriteAccessContext<AttributeEvaluator.Coordinator>
    
    var positionHint: PositionHint { get }
    
    @MainActor
    func makeCoordinator() -> Coordinator
    
    @MainActor
    func updated(
        newValue: AttributeEvaluator.Value,
        oldValue: AttributeEvaluator.Value,
        context: UpdatedContext
    )
    
    @MainActor
    var _attributeEvaluator: AttributeEvaluator { get }
}

public protocol _DVConcreteConstantAttribute: _DVConcreteAttribute {
    associatedtype Value
    
    @MainActor
    func value(context: Context) -> Value
}

public protocol _DVConcreteStateAttribute: _DVConcreteAttribute {
    associatedtype Value
    
    @MainActor
    func defaultValue(in context: Context) -> Value
}

public extension _DVConcreteConstantAttribute {
    @MainActor
    var _attributeEvaluator: _DVConcreteConstantAttributeEvaluator<Self> {
        _DVConcreteConstantAttributeEvaluator(attribute: self)
    }
}

public extension _DVConcreteStateAttribute {
    @MainActor
    var _attributeEvaluator: _DVConcreteStateAttributeEvaluator<Self> {
        _DVConcreteStateAttributeEvaluator(attribute: self)
    }
}

public struct _AnyDVConcreteAttributeEvaluator: _DVConcreteAttributeEvaluator {
    public typealias Value = Any
    public typealias Coordinator = Any
    
    private var base: any _DVConcreteAttributeEvaluator

    public init(base: any _DVConcreteAttributeEvaluator) {
        self.base = base
    }
    
    public func value(
        context: Context
    ) -> Value {
        func _getValue<T: _DVConcreteAttributeEvaluator>(
            _ x: T
        ) -> Any {
            x.value(
                context: .init(
                    store: context.store,
                    transaction: context.transaction,
                    coordinator: context.coordinator as! T.Coordinator,
                    update: context.update
                )
            )
        }
        
        return _getValue(base)
    }
    
    public func associateOverridden(
        value: Value,
        context: Context
    ) -> Value {
        func _associateOverridden<T: _DVConcreteAttributeEvaluator>(
            _ x: T
        ) -> Any {
            x.associateOverridden(
                value: value as! T.Value,
                context: .init(
                    store: context.store,
                    transaction: context.transaction,
                    coordinator: context.coordinator as! T.Coordinator,
                    update: context.update
                )
            )
        }
        
        return _associateOverridden(base)
    }
    
    public func shouldUpdate(
        newValue: Value,
        oldValue: Value
    ) -> Bool {
        func _shouldUpdate<T: _DVConcreteAttributeEvaluator>(
            _ x: T
        ) -> Bool {
            x.shouldUpdate(
                newValue: newValue as! T.Value,
                oldValue: oldValue as! T.Value
            )
        }
        
        return _shouldUpdate(base)
    }
}

public final class _AnyDVConcreteAttribute: _DVConcreteAttribute {
    public typealias PositionHint = AnyHashable
    public typealias AttributeEvaluator = _AnyDVConcreteAttributeEvaluator
    public typealias Coordinator = Any
    
    private var base: any _DVConcreteAttribute
    
    public var positionHint: AnyHashable {
        base.positionHint.erasedAsAnyHashable
    }
    
    @MainActor
    public func makeCoordinator() -> Coordinator {
        base.makeCoordinator()
    }

    @MainActor
    public var _attributeEvaluator: _AnyDVConcreteAttributeEvaluator {
        return _AnyDVConcreteAttributeEvaluator(base: base._attributeEvaluator)
    }
    
    @MainActor
    public init(base: any _DVConcreteAttribute) {
        self.base = base
    }
}

public protocol _DVRefreshableConcreteAttribute where Self: _DVConcreteAttribute {
    typealias RefreshContext = _DVConcreteAttributeReadWriteAccessContext<AttributeEvaluator.Coordinator>
    
    @MainActor
    func refresh(context: RefreshContext) async -> AttributeEvaluator.Value
}

public protocol KeepAliveAttribute where Self: _DVConcreteAttribute {
    
}

public extension _DVConcreteAttribute {
    func makeCoordinator() -> Coordinator where Coordinator == Void {
        ()
    }
    
    func updated(
        newValue: AttributeEvaluator.Value,
        oldValue: AttributeEvaluator.Value,
        context: UpdatedContext
    ) {
        
    }
}

extension _DVConcreteAttribute where Self == PositionHint {
    public var positionHint: Self {
        self
    }
}
