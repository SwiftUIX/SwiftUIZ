//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

@frozen
@propertyWrapper
public struct _LazyState<Value>: _SwiftUIZ_DynamicProperty {
    @usableFromInline
    class Storage: ObservableObject {
        var makeValue: (() -> Value)?
        var _value: Value?
        
        var value: Value {
            get {
                evaluate()
            } set {
                _value = newValue
            }
        }
        
        private func evaluate() -> Value {
            if let _value {
                return _value
            }
            
            self._value = makeValue!()
            
            self.makeValue = nil
            
            return self._value!
        }
        
        @usableFromInline
        init(value: @escaping () -> Value) {
            self.makeValue = value
        }
    }
    
    @usableFromInline
    var _storage: StateObject<Storage>
    
    public var wrappedValue: Value {
        get {
            _storage.wrappedValue.value
        }
    }
    
    @inlinable
    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        self._storage = .init(wrappedValue: Storage(value: wrappedValue))
    }
}
