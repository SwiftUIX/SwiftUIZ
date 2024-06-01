//
// Copyright (c) Vatsal Manot
//

import Merge
import Swallow
import SwiftUI

@propertyWrapper
public final class _PublishedConstantOrBinding<Value>: _SwiftUIZ_DynamicProperty {
    private let base: _ConstantOrBinding<Value?>
    private var binding: _ConstantOrBinding<Value>!
    
    private var parent: (any ObservableObject)?
    private var cacheLastNonNilValue: Bool
    private var lastNonNilValue: Value?
    private var baseWasDestroyed: Bool = false
    
    public var wrappedValue: Value {
        _getValue(base: base)
    }
    
    public var projectedValue: _ConstantOrBinding<Value> {
        binding
    }
    
    private init(
        binding: _ConstantOrBinding<Value?>,
        cacheLastNonNilValue: Bool
    ) {
        self.base = binding
        self.cacheLastNonNilValue = cacheLastNonNilValue
        
        self.binding = binding._mapGetSet(
            get: { [weak self] _ in
                guard let `self` = self else {
                    return binding.wrappedValue!
                }
                
                return self._getValue(base: binding)
            },
            set: { binding, newValue in
                self._setValue(newValue, for: binding)
            }
        )
    }
    
    private convenience init(
        unsafelyUnwrapping binding: _ConstantOrBinding<Value?>
    ) {
        self.init(binding: binding, cacheLastNonNilValue: true)
        
        self.lastNonNilValue = binding.wrappedValue
    }
    
    private func _getValue(base: _ConstantOrBinding<Value?>) -> Value {
        guard !baseWasDestroyed else {
            assert(base.wrappedValue == nil)
            
            return lastNonNilValue!
        }
        
        return base.wrappedValue ?? lastNonNilValue!
    }
    
    private func _setValue(
        _ newValue: Value,
        for binding: some _SwiftUIX_BindingType<Value?>
    ) {
        if let parent = parent {
            (parent.objectWillChange as! _opaque_VoidSender).send()
        }
        
        guard !baseWasDestroyed else {
            assert(base.wrappedValue == nil)
            
            lastNonNilValue = newValue
            
            return
        }
        
        if cacheLastNonNilValue {
            if let existingValue = base.wrappedValue {
                lastNonNilValue = existingValue
                
                binding.wrappedValue = newValue
            } else {
                baseWasDestroyed = true
                lastNonNilValue = newValue
            }
        } else {
            binding.wrappedValue = newValue
        }
    }
    
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: KeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: KeyPath<EnclosingSelf, _PublishedConstantOrBinding<Value>>
    ) -> Value where EnclosingSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            let result = object[keyPath: storageKeyPath].wrappedValue
            
            if object[keyPath: storageKeyPath].parent !== object {
                object[keyPath: storageKeyPath].parent = object
            }
            
            return result
        }
    }
}

extension _PublishedConstantOrBinding {
    public static func unsafelyUnwrapping<T>(
        _ root: T,
        _ keyPath: ReferenceWritableKeyPath<T, Value?>
    ) -> Self {
        self.init(
            binding: _ConstantOrBinding(
                get: { root[keyPath: keyPath] },
                set: { root[keyPath: keyPath] = $0 }
            ),
            cacheLastNonNilValue: true
        )
    }
}
