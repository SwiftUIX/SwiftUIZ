//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Swallow
import SwiftUIX
import _SwiftUIZ_A

protocol _ShallowEnvironmentType: SwiftUI.DynamicProperty, PropertyWrapper, _SwiftUIX_PropertyWrapper {
    var id: AnyHashable? { get }
    var key: PartialKeyPath<_ShallowEnvironmentValues.Keys> { get }
}

@propertyWrapper
public struct _ShallowEnvironment<Value>: _ShallowEnvironmentType {
    @Environment(\._shallowEnvironmentProvider) private var _shallowEnvironmentProvider
    
    @State internal var id: AnyHashable? = UUID()
    
    let key: PartialKeyPath<_ShallowEnvironmentValues.Keys>
    
    public var wrappedValue: Value {
        get {
            #try(.optimistic) {
                let key = _ShallowEnvironmentProvider.EnvironmentKey(id: id!, key: key)
                
                return try _shallowEnvironmentProvider[key, as: Value.self].unwrap()
            }!
        }
    }
    
    public init<Key: _ShallowEnvironmentValues.Key>(
        _ key: KeyPath<_ShallowEnvironmentValues.Keys, Key>
    ) where Value == Key.Value {
        self.key = key
    }
    
    public init<T>(_ type: T.Type) where Value == T? {
        self.key = \_ShallowEnvironmentValues.Keys.[Metatype(T.self)]
    }
}

// MARK: - Auxiliary

@_spi(Internal)
extension EnvironmentValues {
    @EnvironmentValue public var _shallowEnvironmentProvider = _ShallowEnvironmentProvider()
}
