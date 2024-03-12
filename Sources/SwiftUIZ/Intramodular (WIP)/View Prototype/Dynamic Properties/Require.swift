//
// Copyright (c) Vatsal Manot
//

import _DVGraph
import SwiftUI

/*public protocol _DVAttributeProjectable {
    associatedtype _DVProjectionType
    associatedtype _DVUnwrappedType
}

extension Binding: _DVAttributeProjectable {
    public typealias _DVProjectionType = Self
    public typealias _DVUnwrappedType = Self
}

/// A property wrapper type that can watch and read-only access to the given attribute.
@propertyWrapper
public struct Require<Node: _DVConcreteAttribute>: DynamicProperty {
    private let atom: Node
    
    @ViewContext private var context
    
    public init(_ atom: Node, fileID: StaticString = #fileID, line: UInt = #line) {
        self.atom = atom
        self._context = ViewContext(fileID: fileID, line: line)
    }
    
    public var wrappedValue: Node.AttributeEvaluator.Value {
        context.watch(atom)
    }
}

/// A property wrapper type that can watch and read-write access to the given attribute conforms
@propertyWrapper
public struct RequireMutable<Node: _DVConcreteStateAttribute>: DynamicProperty {
    private let atom: Node
    
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
*/
