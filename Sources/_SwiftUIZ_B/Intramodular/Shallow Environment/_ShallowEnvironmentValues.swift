//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public struct _ShallowEnvironmentValues: Initiable {
    package typealias Storage = [PartialKeyPath<Keys>: Any]
    
    package var storage: [PartialKeyPath<Keys>: Any] = [:]
    
    package var keys: Storage.Keys {
        storage.keys
    }
    
    public init() {
        
    }
    
    public subscript<Key: _ShallowEnvironmentValues.Key>(
        _ keyPath: KeyPath<Keys, Key>
    ) -> Key.Value? {
        get {
            storage[keyPath].map({ $0 as! Key.Value })
        } set {
            storage[keyPath] = newValue
        }
    }
    
    public subscript<T>(
        _ type: T.Type
    ) -> T? {
        get {
            storage[\Keys.[Metatype(type)]].map({ $0 as! T })
        } set {
            storage[\Keys.[Metatype(type)]] = newValue
        }
    }
}

extension _ShallowEnvironmentValues {
    public protocol Key<Value>: Hashable {
        associatedtype Value
    }
    
    public struct Keys {
        public struct _TypeToEnvironmentKeyAdaptor<T>: Hashable {
            public typealias Value = T
            
            public let type: Metatype<T>
        }
        
        public subscript<T>(_ type: Metatype<T>) -> _TypeToEnvironmentKeyAdaptor<T> {
            .init(type: type)
        }
    }
}
