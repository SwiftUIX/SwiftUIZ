//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

public protocol _SwiftUIX_ViewParameterKey<Value>: Hashable {
    associatedtype Value
}

public struct _SwiftUIX_ViewParameterKeys {
    
}

extension _SwiftUIX_ViewParameterKeys {
    public struct _TypeToParameterKeyAdaptor<T>: Hashable {
        public typealias Value = T
        
        public let type: Metatype<T>
    }
    
    public subscript<T>(_ type: Metatype<T>) -> _TypeToParameterKeyAdaptor<T> {
        .init(type: type)
    }
}

protocol _ViewParameterType: DynamicProperty, PropertyWrapper {
    var id: AnyHashable? { get }
    var key: PartialKeyPath<_SwiftUIX_ViewParameterKeys> { get }
}

@propertyWrapper
public struct _ViewParameter<Value>: _ViewParameterType {
    @Environment(\._viewProvisionContext) var _viewProvisionContext
    
    @State var id: AnyHashable? = UUID()
    let key: PartialKeyPath<_SwiftUIX_ViewParameterKeys>
    
    public var wrappedValue: Value {
        _viewProvisionContext.storage[.init(key: key, id: id!)] as! Value
    }
    
    public init<Key: _SwiftUIX_ViewParameterKey>(
        _ key: KeyPath<_SwiftUIX_ViewParameterKeys, Key>
    ) where Value == Key.Value {
        self.key = key
    }
    
    public init<T>(_ type: T.Type) where Value == T? {
        self.key = \_SwiftUIX_ViewParameterKeys.[Metatype(T.self)]
    }
}

public struct _SwiftUIX_ViewParameters: Initiable {
    var storage: [PartialKeyPath<_SwiftUIX_ViewParameterKeys>: Any] = [:]
    
    public init() {
        
    }
    
    public subscript<Key: _SwiftUIX_ViewParameterKey>(
        _ keyPath: KeyPath<_SwiftUIX_ViewParameterKeys, Key>
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
            storage[\_SwiftUIX_ViewParameterKeys.[Metatype(type)]].map({ $0 as! T })
        } set {
            storage[\_SwiftUIX_ViewParameterKeys.[Metatype(type)]] = newValue
        }
    }
}

@_spi(Private)
public struct _SwiftUIZ_ParameterReceiverContext: Equatable {
    public var descriptor: _SwiftUIZ_ViewDescriptor
    
    public init(descriptor: _SwiftUIZ_ViewDescriptor) {
        self.descriptor = descriptor
    }
}

extension _SwiftUIZ_ParameterReceiverContext {
    struct _PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = _SwiftUIZ_ParameterReceiverContext?
        
        static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = nextValue() ?? value
        }
    }
}
