//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct _SwiftUIX_ViewTraitValues {
    public struct _StorageValue: _PartiallyEquatable {
        public var namespace: Namespace.ID?
        public var valueBox: any _SwiftUIX_AnyValueBox
        
        public func isEqual(to other: Self) -> Bool? {
            namespace == other.namespace && _isKnownEqual(valueBox.wrappedValue, other.valueBox.wrappedValue)
        }
    }
    
    public typealias _StorageKey = _SwiftUIX_Metatype<any _SwiftUIX_ViewTraitKey.Type>
    
    var storage: [_StorageKey: any _SwiftUIX_AnyValueBox]
    
    public var keys: [_StorageKey] {
        Array(storage.keys)
    }
    
    public init() {
        self.storage = [:]
    }
    
    public subscript<Key: _SwiftUIX_ViewTraitKey>(
        _ key: Key.Type
    ) -> Key.Value {
        get {
            let key = _StorageKey(key)
            
            return storage[key].map({ $0 as! Key.ValueBox })?.wrappedValue ?? Key.defaultValue
        } set {
            let key = _StorageKey(key)
            
            if var box = storage[key].map({ $0 as! Key.ValueBox }) {
                box.wrappedValue = newValue
                
                storage[key] = box
            } else {
                storage[key] = Key.ValueBox(wrappedValue: newValue)
            }
        }
    }
    
    public subscript<Key: _SwiftUIX_ViewTraitKey>(
        _ key: Key
    ) -> Key.Value {
        get {
            self[type(of: key)]
        } set {
            self[type(of: key)] = newValue
        }
    }
    
    public subscript<Key: _SwiftUIX_ViewTraitKey>(
        _raw key: Key.Type
    ) -> Key.ValueBox? {
        get {
            let key = _StorageKey(key)
            
            return storage[key].map({ $0 as! Key.ValueBox })
        } set {
            let key = _StorageKey(key)
            
            storage[key] = newValue
        }
    }
    
    public subscript<Value>(_ type: Value.Type) -> Value? {
        get {
            let key = _SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<Value>()
            
            return self[key]
        } set {
            let key = _SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<Value>()
            
            self[key] = newValue
        }
    }
}

extension _SwiftUIX_ViewTraitValues: _PartiallyEquatable {
    public func isEqual(to other: Self) -> Bool? {
        _isKnownEqual(storage, other.storage)
    }
}

// MARK: - Auxiliary

public enum _SwiftUIX_ViewTraitKeys {
    public struct _MetatypeToViewTraitKeyAdaptor<T>: _SwiftUIX_ViewTraitKey {
        public typealias Value = T?
        
        public static var defaultValue: T? {
            nil
        }
    }
    
    @_spi(Internal)
    public struct _ToSwiftUIViewTraitKeyAdaptor<Base: _SwiftUIX_ViewTraitKey>: _ViewTraitKey {
        public typealias Value = Base.ValueBox
        
        public static var defaultValue: Base.ValueBox {
            .init(wrappedValue: Base.defaultValue)
        }
    }
}
