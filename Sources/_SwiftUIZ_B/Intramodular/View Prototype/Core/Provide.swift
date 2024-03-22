//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
@_spi(Internal) import Merge
import SwiftUIX

extension _Provide: _DVConcreteAttributeConvertible {
    public func __conversion() throws -> any _DVConcreteAttribute {
        valueContainer
    }
}

public protocol _ProvideType<WrappedValue> {
    associatedtype WrappedValue
    
    var wrappedValue: WrappedValue { get }
}

@propertyWrapper
public struct _Provide<Parent, Data, WrappedValue>: _ProvideType, DynamicProperty, Identifiable, PropertyWrapper {
    @Environment(\._dynamicViewGraphContext) public var _dynamicViewGraphContext
    
    package final class _ObservableObject_Implementation {
        public var base: _ProvideValueContainer<WrappedValue>
        
        init(environment: ViewGraphEnvironmentContext?) {
            self.base = .init(environment: environment)
        }
    }
    
    package struct _SwiftUI_Implementation: DynamicProperty {
        @Environment(\._dynamicViewGraphContext) public var _dynamicViewGraphContext
        
        @StateObject private var renderBridge = _ViewPrototypeRenderBridge()
        
        @StateObject var base = _ProvideValueContainer<WrappedValue>(environment: nil)
        
        package init() {
            
        }
        
        package mutating func update() {
            base._dynamicViewGraphContext = _dynamicViewGraphContext
        }
    }
    
    package struct Implementation {
        package enum ImplementationType {
            case _SwiftUI
            case _ObservableObject
        }
        
        package let type: ImplementationType
    }
    
    @State public var id = ViewGraphParticipantID()
    
    package let implementation: Implementation
    package var _imp_ObservableObject = _ObservableObject_Implementation(environment: nil)
    package var _imp_SwiftUI: _SwiftUI_Implementation!
    
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
        } nonmutating set {
            _rawWrappedValue = newValue
        }
    }
    
    public static subscript<EnclosingSelf>(
        _enclosingInstance _enclosingInstance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, WrappedValue>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, _Provide>
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
            if _enclosingInstance[keyPath: storageKeyPath].implementation.type == ._ObservableObject {
                if _enclosingInstance[keyPath: storageKeyPath].valueContainer.enclosingInstance == nil {
                    _enclosingInstance[keyPath: storageKeyPath].valueContainer.enclosingInstance = _enclosingInstance as? (any ObservableObject)
                }
            }

            _enclosingInstance[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
    
    public var projectedValue: Self {
        get {
            self
        }
    }
    
    public init(
        wrappedValue: WrappedValue
    ) where Parent: ObservableObject, Data == ConstantDataSource<WrappedValue> {
        self.implementation = .init(type: ._ObservableObject)
        self._rawWrappedValue = wrappedValue
    }
    
    public mutating func update() {
        self.valueContainer._dynamicViewGraphContext = _dynamicViewGraphContext
    }
}

extension ObservableObject {
    public typealias Provide<T, U> = _Provide<Self, T, U>
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

public final class _ProvideValueContainer<WrappedValue>: ObservableObject, ViewGraphParticipant, _DVConcreteObservableObjectAttribute {
    public var _isAttributeResolved: Bool {
        self.wrappedValue != nil
    }
    
    private var _resolved_dynamicViewGraphContext: ViewGraphEnvironmentContext!
    
    public var _dynamicViewGraphContext: ViewGraphEnvironmentContext {
        get {
            _resolved_dynamicViewGraphContext
        } set {
            _resolved_dynamicViewGraphContext = newValue
        }
    }
    
    public typealias Context = _DVConcreteAttributeTransactionalAccessContext<Void>
    public typealias Coordinator = Void
    public typealias ObjectType = _ProvideValueContainer<WrappedValue>
    
    public weak var enclosingInstance: (any ObservableObject)?
    
    public let id = ViewGraphParticipantID()
    
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
    
    public init(
        wappedValue: WrappedValue? = nil,
        environment: ViewGraphEnvironmentContext?
    ) {
        self._wappedValue = wappedValue
        self._resolved_dynamicViewGraphContext = environment
    }
    
    public func object(
        context: Context
    ) -> _ProvideValueContainer<WrappedValue> {
        self
    }
}
