//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public protocol DVAttributeNodeTransactionState<AttributeType>: AnyObject {
    associatedtype AttributeType: _DVConcreteAttribute
    
    typealias Coordinator = AttributeType.Coordinator
    
    var coordinator: Coordinator { get }
    var transaction: _DVConcreteAttributeTransaction? { get set }
}

public final class _AnyDVAttributeNodeTransactionState<AttributeType: _DVConcreteAttribute>: DVAttributeNodeTransactionState {
    public let coordinator: AttributeType.Coordinator
    public var transaction: _DVConcreteAttributeTransaction?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

@MainActor
public protocol _DVAttributeNodeCache: CustomStringConvertible {
    associatedtype Node: _DVConcreteAttribute
    
    var attribute: Node { get set }
    var value: Node.AttributeEvaluator.Value { get set }
}

extension _DVAttributeNodeCache {
    public var description: String {
        "\(value)"
    }
}

public struct _DVConcreteAttributeCache<T: _DVConcreteAttribute>: _DVAttributeNodeCache {
    public var attribute: T
    public var value: T.AttributeEvaluator.Value
    
    public init(
        attribute: T,
        value: T.AttributeEvaluator.Value
    ) {
        self.attribute = attribute
        self.value = value
    }
}

@MainActor
public final class _DVConcreteAttributeGraph {
    public struct StructureDescription: Equatable {
        public var dependencies = [DVAttributeNodeID: Set<DVAttributeNodeID>]()
        public var children = [DVAttributeNodeID: Set<DVAttributeNodeID>]()
    }
    
    public struct StoreState {
        public var caches = [DVAttributeNodeID: any _DVAttributeNodeCache]()
        public var states = [DVAttributeNodeID: any DVAttributeNodeTransactionState]()
        public var subscriptionsByNode = [DVAttributeNodeID: [_DVConcreteAttributeSubscriptionGroup.ID: _DVConcreteAttributeSubscription]]()
    }

    @MainActor(unsafe)
    public var owner: _DVGraph!
    
    public var structureDescription = StructureDescription()
    public var state = StoreState()
    
    public init(owner: _DVGraph = .init(invalid: ())) {
        self.owner = owner
    }
}

extension _DVConcreteAttributeGraph {
    public final class Scope: CustomStringConvertible, Hashable {
        @inlinable
        public var description: String {
            String(hashValue, radix: 36, uppercase: false)
        }
        
        public init() {
            
        }
        
        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }
        
        @inlinable
        public static func == (lhs: _DVConcreteAttributeGraph.Scope, rhs: _DVConcreteAttributeGraph.Scope) -> Bool {
            lhs === rhs
        }
    }
}

extension _DVConcreteAttributeGraph {
    public struct Override: Hashable {
        @usableFromInline
        let identifier: Identifier
        
        public init<T: _DVConcreteAttribute>(_ x: T) {
            let positionHint = AnyHashable(x.positionHint)
            let type = ObjectIdentifier(T.self)
            
            identifier = .attributeNode(positionHint: positionHint, type: type)
        }
        
        public init<T: _DVConcreteAttribute>(_: T.Type) {
            let type = ObjectIdentifier(T.self)
            
            identifier = .type(type)
        }
    }
}

extension _DVConcreteAttributeGraph.Override {
    public enum Identifier: Hashable {
        case attributeNode(positionHint: AnyHashable, type: ObjectIdentifier)
        case type(ObjectIdentifier)
    }
}

public struct DVAttributeNodeID: Hashable, CustomStringConvertible {
    private let key: AnyHashable
    private let type: ObjectIdentifier
    private let overrideScopeKey: _DVConcreteAttributeGraph.Scope?
    private let getName: () -> String
    
    public var isOverridden: Bool {
        overrideScopeKey != nil
    }
    
    public var description: String {
        if let overrideScopeKey {
            return getName() + "-override:\(overrideScopeKey)"
        }
        else {
            return getName()
        }
    }
    
    public init<T: _DVConcreteAttribute>(
        _ attribute: T,
        overrideScopeKey: _DVConcreteAttributeGraph.Scope?
    ) {
        self.key = AnyHashable(attribute.positionHint)
        self.type = ObjectIdentifier(T.self)
        self.overrideScopeKey = overrideScopeKey
        self.getName = { String(describing: T.self) }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(type)
        hasher.combine(overrideScopeKey)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key && lhs.type == rhs.type && lhs.overrideScopeKey == rhs.overrideScopeKey
    }
}
