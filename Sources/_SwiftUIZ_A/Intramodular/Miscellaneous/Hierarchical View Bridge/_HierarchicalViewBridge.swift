//
// Copyright (c) Vatsal Manot
//

import Combine
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
    
    func add(_ instance: _HierarchicalViewBridge<InstanceType>)
}

extension _HierarchicalViewBridgeType {
    public func _opaque_add(_ instance: Any) {
        self.add(instance as! _HierarchicalViewBridge<InstanceType>)
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
    
    init(invalid: Void) {
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
    
    /// Whether this instance supersedes another instance that is detected as below it.
    open func supersedes<T: _HierarchicalViewBridge>(
        _ other: T
    ) -> Bool {
        true
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
