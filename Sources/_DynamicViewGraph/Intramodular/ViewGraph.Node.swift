//
// Copyright (c) Vatsal Manot
//

import Merge
import SwiftUIX

extension ViewGraph {
    public class Node: CustomStringConvertible, HashEquatable, Identifiable {
        public enum StateFlag {
            case resolved
        }
        
        unowned let graph: ViewGraph
        
        package let typeDescriptor: ViewTypeDescriptor
        
        public let id = _AutoIncrementingIdentifier<ViewGraph.Node>()
        public var state: Set<StateFlag> = []
        public var attributes: [DVAttributeNodeID: any _DVConcreteAttributeConvertible] = [:]
        public var associatedItems: Set<AssociatedItemID> = []
                
        public weak var parent: Node?
        
        public var parentChain: AnySequence<Node> {
            guard let parent else {
                return .init([])
            }
            
            return [parent].join(parent.parentChain).eraseToAnySequence()
        }
        
        public var description: String {
            "#\(id)"
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        package init(
            graph: ViewGraph,
            typeDescriptor: ViewTypeDescriptor
        ) {
            self.graph = graph
            self.typeDescriptor = typeDescriptor
        }
        
        public func update() throws {
            let attributesResolved = try !attributes.values.contains(where: { try !$0.__conversion()._isAttributeResolved })
            
            if attributesResolved {
                state.insert(.resolved)
            } else {
                state.remove(.resolved)
            }
        }
        
        public func associate(_ x: any ViewGraphParticipant) {
            x.enterAssociation(with: self)
            
            self.associatedItems.insert(.init(from: x))
        }
    }
}
