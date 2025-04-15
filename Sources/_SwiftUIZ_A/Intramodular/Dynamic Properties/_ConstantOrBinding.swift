//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwallowMacrosClient
import SwiftUI

@dynamicMemberLookup
@propertyWrapper
public struct _ConstantOrBinding<Value>: _SwiftUIZ_DynamicProperty {
    fileprivate enum Base {
        case constant(Value)
        case lazyConstant(() -> Value)
        case binding(any _SwiftUIX_BindingType<Value>)
        
        func evaluate() -> Value {
            switch self {
                case .constant(let value):
                    return value
                case .lazyConstant(let value):
                    return value()
                case .binding(let binding):
                    return binding.wrappedValue
            }
        }
    }
    
    private let _base: Base?
    private let _swiftUIBinding: Binding<Value>
    
    private var base: Base {
        if let base = _base {
            return base
        } else {
            return .binding(_swiftUIBinding)
        }
    }
    
    private var _baseOrSwiftUIBinding: Either<Base, Binding<Value>> {
        _base.map(Either.left) ?? Either.right(_swiftUIBinding)
    }
    
    public var wrappedValue: Value {
        get {
            base.evaluate()
        }
    }
    
    public var binding: any _SwiftUIX_BindingType<Value> {
        get throws {
            guard case .binding(let binding) = base else {
                #throw
            }
            
            return binding
        }
    }
    
    public var _unsafeAssumedBoundValue: Value {
        get {
            try! binding.wrappedValue
        } nonmutating set {
            try! binding.wrappedValue = newValue
        }
    }
    
    public var projectedValue: Self {
        self
    }
    
    fileprivate init(base: Either<Base, Binding<Value>>) {
        self._base = base.leftValue
        self._swiftUIBinding = base.reduce(
            left: { base in Binding(get: { base.evaluate() }, set: { _ in assertionFailure() }) },
            right: { $0 as Binding }
        )
    }
    
    public subscript<Subject>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> _ConstantOrBinding<Subject> {
        switch _baseOrSwiftUIBinding {
            case .left(let base):
                switch base {
                    case .constant:
                        return .init(base: .left(.lazyConstant({ self.wrappedValue[keyPath: keyPath] })))
                    case .lazyConstant:
                        return .init(base: .left(.lazyConstant({ self.wrappedValue[keyPath: keyPath] })))
                    case .binding(let binding):
                        return .init(
                            get: { binding.wrappedValue[keyPath: keyPath] },
                            set: { binding.wrappedValue[keyPath: keyPath] = $0 }
                        )
                }
            case .right(let binding):
                return .init(base: .right(binding[dynamicMember: keyPath]))
        }
    }
    
    func _mapGetSet<T>(
        get: @escaping @Sendable (Value) -> T,
        set: @escaping @Sendable (any _SwiftUIX_BindingType<Value>, T) -> Void
    ) -> _ConstantOrBinding<T> {
        switch _baseOrSwiftUIBinding {
            case .left(let base):
                switch base {
                    case .constant(let value):
                        return .init(base: .left(.constant(get(value))))
                    case .lazyConstant(let value):
                        return .init(base: .left(.lazyConstant({ get(value()) })))
                    case .binding(let binding):
                        return .init(base: .left(.binding(Inout(get: { get(binding.wrappedValue) }, set: { set(binding, $0) }))))
                }
            case .right(let binding):
                return .init(base: .right(SwiftUI.Binding(get: { get(binding.wrappedValue) }, set: { set(binding, $0) })))
        }
    }
}

// MARK: - Initializers

extension _ConstantOrBinding {
    public init(
        get: @escaping @Sendable () -> Value,
        set: @escaping @Sendable (Value) -> Void
    ) {
        self.init(base: .left(.binding(Inout(get: get, set: set))))
    }
    
    public static func binding<Binding: _SwiftUIX_BindingType>(
        _ binding: Binding
    ) -> Self where Binding.Value == Value {
        Self(base: (binding as? SwiftUI.Binding<Value>).map(Either.right) ?? Either.left(Base.binding(binding)))
    }
    
    public static func binding<Binding: _SwiftUIX_BindingType>(
        _ binding: @escaping @Sendable () -> Binding
    ) -> Self where Binding.Value == Value {
        .init(get: { binding().wrappedValue }, set: { binding().wrappedValue = $0 })
    }
    
    public static func constant(_ value: Value) -> Self {
        Self(base: .left(.constant(value)))
    }
}

extension _ConstantOrBinding {
    public static func unsafelyUnwrapping<T>(
        _ root: T,
        _ keyPath: ReferenceWritableKeyPath<T, Value?>
    ) -> Self {
        unsafelyUnwrapping(
            Inout(
                get: { root[keyPath: keyPath] },
                set: { root[keyPath: keyPath] = $0 }
            )
        )
    }
    
    public static func unsafelyUnwrapping<Binding: _SwiftUIX_BindingType>(
        _ binding: @escaping () -> Binding
    ) -> Self where Binding.Value == Optional<Value> {
        let initialValue = binding().wrappedValue!
        
        return .init(
            get: { binding().wrappedValue ?? initialValue },
            set: { binding().wrappedValue = $0 }
        )
    }
    
    @_disfavoredOverload
    public static func unsafelyUnwrapping<Binding: _SwiftUIX_BindingType>(
        _ binding: @autoclosure @escaping () -> Binding
    ) -> Self where Binding.Value == Optional<Value> {
        unsafelyUnwrapping({ binding() })
    }
}

// MARK: - Extensions

extension _ConstantOrBinding {
    public func onWillSet(_ body: @escaping (Value) -> ()) -> Self {
        _mapGetSet(
            get: { $0 },
            set: { binding, newValue in
                body(newValue)
                
                binding.wrappedValue = newValue
            }
        )
    }
    
    public func onDidSet(_ body: @escaping (Value) -> ()) -> Self {
        _mapGetSet(
            get: { $0 },
            set: { binding, newValue in
                binding.wrappedValue = newValue
                
                body(newValue)
            }
        )
    }
}

extension _ConstantOrBinding {
    public func _cast<T>(
        to type: T.Type = T.self
    ) -> _ConstantOrBinding<Optional<T>> {
        _mapGetSet(
            get: {
                $0 as? T
            },
            set: { (binding, newValue) in
                guard let _newValue = newValue as? Value else {
                    assertionFailure()
                    
                    return
                }
                
                binding.wrappedValue = _newValue
            }
        )
    }
    
    /// Creates a `Binding` by force-casting this binding's value.
    public func forceCast<T>(to type: T.Type = T.self) -> _ConstantOrBinding<T> {
        _mapGetSet(get: { $0 as! T } , set: { $0.wrappedValue = $1 as! Value })
    }
}

// MARK: - Conformances

extension _ConstantOrBinding: Equatable where Value: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension _ConstantOrBinding: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

// MARK: - SwiftUI Additions

extension Binding {
    public init(_ x: _ConstantOrBinding<Value>) {
        switch x.kind {
            case .constant:
                self = .constant(x.wrappedValue)
            case .binding:
                let binding = try! x.binding
                
                self.init(
                    get: { binding.wrappedValue },
                    set: { binding.wrappedValue = $0 }
                )
        }
    }
}

// MARK: - Auxiliary

extension _ConstantOrBinding {
    public enum Kind: Hashable, Sendable {
        case constant
        case binding
    }
    
    public var kind: Kind {
        switch base {
            case .constant, .lazyConstant:
                return .constant
            case .binding:
                return .binding
        }
    }
}
