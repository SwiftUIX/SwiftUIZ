//
// Copyright (c) Vatsal Manot
//

import Merge
import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

extension _DynamicViewGraphLite {
    public final class Node: _DynamicViewGraphNodeType {
        public typealias ID = _ViewGraphNodeID
        
        unowned let graph: any _DynamicViewGraphType
        public let staticViewTypeDescriptor: _StaticViewTypeDescriptor
        
        public let id = _ViewGraphNodeID()
        public var state: ViewGraphNodeState = []
        public var elementProperties: [_ViewAttributeID: any _ConsumableDynamicViewElementProperty] = [:]
        public var elements = IdentifierIndexingArray<any _DynamicViewGraphElement, _DynamicViewElementID>(id: \._viewGraphElementID)
        
        public var staticViewDescription = _ViewTypeDescription()
        
        public weak var parent: Node?
        
        public var swizzledViewBody: (any View)? {
            nil
        }
        
        package init(
            graph: any _DynamicViewGraphType,
            typeDescriptor: _StaticViewTypeDescriptor
        ) {
            self.graph = graph
            self.staticViewTypeDescriptor = typeDescriptor
        }
        
        public func update() throws {
            let attributesResolved = try !elementProperties.values.contains(where: { try !$0._isAttributeResolved })
            
            if attributesResolved {
                state.insert(.resolved)
            } else {
                state.remove(.resolved)
            }
        }
    }
}

// MARK: - Conformances

extension _DynamicViewGraphLite.Node: CustomStringConvertible {
    public var description: String {
        "#\(id)"
    }
}

extension _DynamicViewGraphLite.Node: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}