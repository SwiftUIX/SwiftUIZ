//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import SwiftUI

public protocol _DVAttributeProjectable {
    associatedtype _DVProjectionType
    associatedtype _DVUnwrappedType
}

extension Binding: _DVAttributeProjectable {
    public typealias _DVProjectionType = Self
    public typealias _DVUnwrappedType = Self
}

/// A property wrapper type that can watch and read-only access to the given attribute.
@propertyWrapper
public struct Require<WrappedValue>: DynamicProperty, PropertyWrapper {
    @Environment(\._dynamicViewGraphContext) public var _dynamicViewGraphContext
    @ViewContext private var context
    
    @State public var id = ViewGraphParticipantID()
    
    public init(
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self._context = ViewContext(fileID: fileID, line: line)
    }
    
    public var wrappedValue: WrappedValue {
        get {
            context.watch(
                _ProvideValueContainer<WrappedValue>(environment: _dynamicViewGraphContext)
            ).wrappedValue!
        } nonmutating set {
            let attribute = context.read(
                _ProvideValueContainer(
                    wappedValue: newValue,
                    environment: _dynamicViewGraphContext
                )
            )
            
            attribute.wrappedValue = newValue
        }
    }
}

extension Require: _DVConcreteAttributeConvertible {
    public func __conversion() throws -> any _DVConcreteAttribute {
        context.watch(_ProvideValueContainer<WrappedValue>(environment: _dynamicViewGraphContext))
    }
}

/// A property wrapper type that can watch and read-write access to the given attribute conforms
@propertyWrapper
public struct RequireMutable<Node: _DVConcreteStateAttribute>: ViewGraphParticipant {
    @Environment(\._dynamicViewGraphContext) public var _dynamicViewGraphContext

    private let atom: Node
    
    @State public private(set) var id = ViewGraphParticipantID()
    
    @ViewContext private var context
    
    /// Creates an instance with the attribute to watch.
    public init(
        _ x: Node,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.atom = x
        self._context = ViewContext(fileID: fileID, line: line)
    }
    
    public var wrappedValue: Node.AttributeEvaluator.Value {
        get {
            context.watch(atom)
        } nonmutating set {
            context.set(
                newValue,
                for: atom
            )
        }
    }
    
    public var projectedValue: Binding<Node.AttributeEvaluator.Value> {
        context.state(atom)
    }
    
    public func enterAssociation(with node: ViewGraph.Node) {
        _context.enterAssociation(with: node)
    }
}

/// A property wrapper type that can watch the given attribute conforms to ``ObservableObjectAtom``.
@propertyWrapper
public struct RequireObservable<Node: _DVConcreteObservableObjectAttribute>: DynamicProperty {
    private let atom: Node
    
    @ViewContext
    private var context
    
    public init(
        _ atom: Node,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.atom = atom
        self._context = ViewContext(fileID: fileID, line: line)
    }
    
    public var wrappedValue: Node.AttributeEvaluator.Value {
        context.watch(atom)
    }
    
    public var projectedValue: Wrapper {
        Wrapper(wrappedValue)
    }
}

extension RequireObservable {
    @dynamicMemberLookup
    public struct Wrapper {
        private let object: Node.AttributeEvaluator.Value
        public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Node.AttributeEvaluator.Value, T>) -> Binding<T> {
            Binding(
                get: { object[keyPath: keyPath] },
                set: { object[keyPath: keyPath] = $0 }
            )
        }
        
        fileprivate init(_ object: Node.AttributeEvaluator.Value) {
            self.object = object
        }
    }
}

