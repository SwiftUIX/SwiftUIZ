//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Swallow

@propertyWrapper
public struct _ConstantOrStateOrBinding<Value>: DynamicProperty  {
    public enum Kind {
        case constant
        case binding
        case state
    }
    
    public let kind: Kind
    
    private let _constant: Value?
    private let _binding: Binding<Value>
    private let _state: State<Value?>
    
    public var wrappedValue: Value {
        get {
            switch kind {
                case .constant:
                    return _constant!
                case .binding:
                    return _binding.wrappedValue
                case .state:
                    return _state.wrappedValue!
            }
        } nonmutating set {
            switch kind {
                case .constant:
                    assertionFailure()
                    
                    return
                case .binding:
                    _binding.wrappedValue = newValue
                case .state:
                    _state.wrappedValue = newValue
            }
        }
    }
    
    public var projectedValue: Binding<Value> {
        switch kind {
            case .constant:
                return .constant(_constant!)
            case .binding:
                return _binding.projectedValue
            case .state:
                return _state.projectedValue.forceUnwrap()
        }
    }
    
    init(constant: Value) {
        self.kind = .constant
        self._constant = constant
        self._binding = .init(get: { constant }, set: { _ in assertionFailure() })
        self._state = .init(initialValue: nil)
    }
    
    init(state initialValue: Value) {
        self.kind = .state
        self._constant = nil
        self._binding = .init(get: { initialValue }, set: { _ in })
        self._state = .init(initialValue: initialValue)
    }

    init(binding: Binding<Value>) {
        self.kind = .binding
        self._constant = nil
        self._binding = binding
        self._state = .init(initialValue: nil)
    }

    public static func constant(_ constant: Value) -> Self {
        .init(constant: constant)
    }
    
    public static func state(initialValue: Value) -> Self {
        .init(state: initialValue)
    }
    
    public static func binding(_ binding: Binding<Value>) -> Self {
        .init(binding: binding)
    }
    
    public static func binding(
        get: @escaping () -> Value,
        set: @escaping (Value) -> Void
    ) -> Self {
        binding(Binding(get: get, set: set))
    }
}
