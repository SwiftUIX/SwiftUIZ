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
    
    private init(invalid: Void) {
        stateFlags.insert(.invalid)
    }
    
    public init() {
        
    }
    
    public func add(
        _ instance: _HierarchicalViewBridge<InstanceType>
    ) {
        assert(instance._parent == nil)
        
        guard instance._parent !== self else {
            return
        }
        
        instance._parent = self
        
        children.insert(WeakObjectPointer(wrappedValue: instance))
        
        _cleanUpChildren()
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
    
    open func supersedes<T: _HierarchicalViewBridge>(_ other: T) -> Bool {
        false
    }
    
    private func _cleanUpChildren() {
        children.removeAll(where: {
            $0.wrappedValue == nil
        })
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
        environment(\.[_viewBridgeType: Metatype(T.InstanceType.self)], Weak(Optional.some(bridge as! T.InstanceType)))
    }
}

struct _HostViewBridge<Bridge: _HierarchicalViewBridgeType, Content: View>: _ThinViewModifier {
    @ObservedObject var bridge: Bridge
    
    var _weakBridge: Weak<Bridge.InstanceType> {
        Weak(Optional.some(bridge as! Bridge.InstanceType))
    }
    
    func body(
        content: Content
    ) -> some View {
        content
            .environment(\.[_viewBridgeType: Metatype(Bridge.InstanceType.self)], _weakBridge)
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    struct _HierarchicalViewBridgeKey<T>: EnvironmentKey {
        typealias Value = Weak<T>
        
        static var defaultValue: Value {
            .init(nil)
        }
    }
    
    subscript<T>(
        _viewBridgeType type: Metatype<T.Type>
    ) -> Weak<T> {
        get {
            self[_HierarchicalViewBridgeKey<T>.self]
        } set {
            self[_HierarchicalViewBridgeKey<T>.self] = newValue
        }
    }
}
