//
// Copyright (c) Vatsal Manot
//

import Merge
import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

extension _LightweightViewHypergraph {
    public final class Interpose: _AnyViewHypergraph.InterposeProtocol {
        public typealias ID = _AnyViewHypergraph.InterposeID
        
        unowned let graph: any _AnyViewHypergraphType
        public let staticViewTypeDescriptor: _StaticViewTypeDescriptor
        
        public let id = _AnyViewHypergraph.InterposeID()
        public var state: ViewInterpositionState = []
        public var elementProperties: [_ViewHyperpropertyID: any _ConsumableViewHypergraphElementProperty] = [:]
        public var elements = IdentifierIndexingArray<any _HeavyweightViewHypergraphElement, _HeavyweightViewHypergraphElementID>(id: \._viewGraphElementID)
        
        public var staticViewDescription = _ViewTypeDescription()
        
        public weak var parent: Interpose?
                
        package init(
            graph: any _AnyViewHypergraphType,
            typeDescriptor: _StaticViewTypeDescriptor
        ) {
            self.graph = graph
            self.staticViewTypeDescriptor = typeDescriptor
        }
    }
}

extension _LightweightViewHypergraph.Interpose {
    public var swizzledViewBody: (any View)? {
        nil
    }

    public func update() throws {
        let attributesResolved = try !elementProperties.values.contains(where: { try !$0._isConsumableResolved })
        
        if attributesResolved {
            state.insert(.resolved)
        } else {
            state.remove(.resolved)
        }
    }
}

// MARK: - Conformances

extension _LightweightViewHypergraph.Interpose: CustomStringConvertible {
    public var description: String {
        "#\(id)"
    }
}

extension _LightweightViewHypergraph.Interpose: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
