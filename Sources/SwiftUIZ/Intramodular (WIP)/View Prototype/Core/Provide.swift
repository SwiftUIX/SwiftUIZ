//
// Copyright (c) Vatsal Manot
//

import _DVGraph
@_spi(Internal) import Merge
import SwiftUIX

public protocol _DVConcreteAttributeConvertible {
    func __conversion() throws -> any _DVConcreteAttribute
}

extension _Provide: _DVConcreteAttributeConvertible {
    public func __conversion() throws -> any _DVConcreteAttribute {
        valueContainer
    }
}

@propertyWrapper
public struct _Provide<Parent, Data, WrappedValue>: DynamicProperty, PropertyWrapper {
    public final class _ObservableObject_Implementation {
        public lazy var base = _ProvideValueContainer<WrappedValue>()
    }
    
    public struct _SwiftUI_Implementation: DynamicProperty {
        @StateObject private var renderBridge = _ViewPrototypeRenderBridge()
        
        @StateObject var base = _ProvideValueContainer<WrappedValue>()
    }
    
    public struct Implementation {
        public enum ImplementationType {
            case _SwiftUI
            case _ObservableObject
        }
        
        public let type: ImplementationType
    }
    
    public let implementation: Implementation
    public var _imp_ObservableObject = _ObservableObject_Implementation()
    public var _imp_SwiftUI = _SwiftUI_Implementation()
    
    public var valueContainer: _ProvideValueContainer<WrappedValue> {
        switch implementation.type {
            case ._ObservableObject:
                return _imp_ObservableObject.base
            case ._SwiftUI:
                return _imp_SwiftUI.base
        }
    }
    
    var _rawWrappedValue: WrappedValue {
        get {
            valueContainer.wrappedValue!
        } nonmutating set {
            valueContainer.wrappedValue = newValue
        }
    }
    
    public var wrappedValue: WrappedValue {
        get {
            _rawWrappedValue
        } set {
            _rawWrappedValue = newValue
        }
    }
    
    @inlinable
    public static subscript<EnclosingSelf>(
        _enclosingInstance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, WrappedValue>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> WrappedValue {
        get {
            if _enclosingInstance[keyPath: storageKeyPath].implementation.type == ._ObservableObject {
                if _enclosingInstance[keyPath: storageKeyPath].valueContainer.enclosingInstance == nil {
                    _enclosingInstance[keyPath: storageKeyPath].valueContainer.enclosingInstance = _enclosingInstance as? (any ObservableObject)
                }
            }
            
            let result: WrappedValue = _enclosingInstance[keyPath: storageKeyPath].wrappedValue
            
            return result
        } set {
            _enclosingInstance[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
    
    public var projectedValue: Self {
        get {
            self
        }
    }
}


extension ObservableObject {
    public typealias Provide<T, U> = _Provide<Self, T, U>
}

extension _Provide {
    public init(
        wrappedValue: WrappedValue
    ) where Parent: ObservableObject, Data == ConstantDataSource<WrappedValue> {
        self.implementation = .init(type: ._ObservableObject)
        self._rawWrappedValue = wrappedValue
    }
}

extension _Provide {
    public init<Subject>(
        _ subject: Subject
    ) where Parent: View, Data == ConstantDataSource<Subject>, WrappedValue == Never {
        self.implementation = .init(type: ._SwiftUI)
        
        fatalError()
    }
    
    public init(
        _ keyPath: KeyPath<Parent, WrappedValue>
    ) where Parent: View, Data == WrappedValue {
        self.implementation = .init(type: ._SwiftUI)
    }
    
    public init(
        _ keyPath: KeyPath<Parent, Published<WrappedValue>.Publisher>
    ) where Parent: View, Data == WrappedValue {
        self.implementation = .init(type: ._SwiftUI)
    }
    
    public init(
        _ keyPath: KeyPath<Parent, Binding<WrappedValue>>
    ) where Parent: View, Data == WrappedValue {
        self.implementation = .init(type: ._SwiftUI)
    }
    
    @_disfavoredOverload
    public init<T>(
        _ keyPath: KeyPath<T, WrappedValue>
    ) where Parent: View, Data == WrappedValue {
        self.implementation = .init(type: ._SwiftUI)
    }
}

extension _Provide: View {
    public var body: some View {
        ZeroSizeView()
    }
}

extension DynamicView {
    public typealias Provide<T, U> = _Provide<Self, T, U>
}

public final class _ProvideValueContainer<WrappedValue>: ObservableObject, _DVConcreteObservableObjectAttribute {
    public typealias Context = _DVConcreteAttributeTransactionalAccessContext<Void>
    public typealias Coordinator = Void
    public typealias ObjectType = _ProvideValueContainer<WrappedValue>
    
    public weak var enclosingInstance: (any ObservableObject)?
    
    public var id = UUID()
    
    @Published public var _wappedValue: WrappedValue? {
        willSet {
            _ObservableObject_objectWillChange_send(enclosingInstance)
        }
    }
    
    public var wrappedValue: WrappedValue? {
        get {
            _wappedValue
        } set {
            _wappedValue = newValue
        }
    }
    
    public var positionHint: AnyHashable {
        id
    }
    
    public init(wappedValue: WrappedValue? = nil) {
        self._wappedValue = wappedValue
    }
    
    public func object(context: Context) -> _ProvideValueContainer<WrappedValue> {
        self
    }
}
