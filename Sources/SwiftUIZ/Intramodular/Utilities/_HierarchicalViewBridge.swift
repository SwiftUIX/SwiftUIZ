//
// Copyright (c) Vatsal Manot
//

import Swallow
import Swift
@_spi(Internal) import SwiftUIX

public protocol __HierarchicalViewBridgeType {
    
}

public protocol _HierarchicalViewBridgeType: __HierarchicalViewBridgeType, AnyObject, ObservableObject {
    associatedtype InstanceType
    
    typealias StateFlag = _HierarchicalViewBridge<InstanceType>.StateFlag
    
    var stateFlags: Set<StateFlag> { get }
    var isInvalid: Bool { get }
}

@propertyWrapper
public struct _ViewBridge<T: _HierarchicalViewBridgeType>: DynamicProperty {
    @Environment(\.[Metatype(T.InstanceType.self)]) var _bridge: Weak<T.InstanceType>
    
    public var wrappedValue: T {
        _bridge.wrappedValue as! T
    }
    
    public init(_: T.Type) {
        
    }
}

open class _HierarchicalViewBridge<InstanceType>: _HierarchicalViewBridgeType {
    public typealias _Self = _HierarchicalViewBridge<InstanceType>
    
    public enum StateFlag: Hashable {
        case invalid
        case destroyed
    }
    
    public var stateFlags: Set<StateFlag> = []
    
    public var isInvalid: Bool {
        stateFlags.contains(.invalid)
    }
    
    private weak var _parent: _Self? {
        willSet {
            assert(_parent == nil)
        }
    }
    
    public fileprivate(set) var children: Set<WeakObjectPointer<_Self>> = []
    
    public func add(_ instance: _HierarchicalViewBridge<InstanceType>) {
        assert(instance._parent == nil)
        
        guard instance._parent !== self else {
            return
        }
        
        instance._parent = self
        
        children.insert(.init(wrappedValue: instance))
    }
    
    private init(invalid: Void) {
        stateFlags.insert(.invalid)
    }
    
    public init() {
        
    }
    
    private func removeFromParent() {
        assert(!stateFlags.contains(.destroyed))
        
        _parent?.children.remove(.init(wrappedValue: self))
        _parent = nil
        
        stateFlags.insert(.destroyed)
    }
    
    deinit {
        removeFromParent()
    }
}

extension _HierarchicalViewBridge: Hashable {
    public static func == (lhs: _HierarchicalViewBridge<InstanceType>, rhs: _HierarchicalViewBridge<InstanceType>) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension View {
    public func _host<T: _HierarchicalViewBridgeType>(
        _ bridge: T
    ) -> some View {
        environment(\.[Metatype(T.InstanceType.self)], Weak(Optional.some(bridge as! T.InstanceType)))
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    public struct _HierarchicalViewBridgeKey<T>: EnvironmentKey {
        public typealias Value = Weak<T>
        
        public static var defaultValue: Value {
            .init(nil)
        }
    }
    
    public subscript<T>(
        _ type: Metatype<T.Type>
    ) -> Weak<T> {
        get {
            self[_HierarchicalViewBridgeKey<T>.self]
        } set {
            self[_HierarchicalViewBridgeKey<T>.self] = newValue
        }
    }
}
