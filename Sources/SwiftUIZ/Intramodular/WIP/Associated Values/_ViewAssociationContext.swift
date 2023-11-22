//
// Copyright (c) Vatsal Manot
//

import Swallow

extension _ViewAssociationContext {
    public static let invalid = _Self(invalid: ())
}

public final class _ViewAssociationContext: ObservableObject {
    public typealias _Self = _ViewAssociationContext
    
    public enum StateFlag {
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
        
    func adopt(_ instance: _Self) {
        instance._parent = self
        
        children.insert(.init(wrappedValue: instance))
    }
    
    private init(invalid: Void) {
        stateFlags.insert(.invalid)
    }
    
    init() {
        
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

extension _ViewAssociationContext: Hashable {
    public static func == (lhs: _Self, rhs: _Self) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    public struct _ViewAssociationContextKey: EnvironmentKey {
        public static let defaultValue = Weak<_ViewAssociationContext>(_ViewAssociationContext.invalid)
    }
    
    public var _viewAssociationContext: Weak<_ViewAssociationContext> {
        get {
            self[_ViewAssociationContextKey.self]
        } set {
            guard let _newValue = newValue.wrappedValue else {
                return
            }
            
            assert(!_newValue.isInvalid)
            
            self[_ViewAssociationContextKey.self] = newValue
        }
    }
}
