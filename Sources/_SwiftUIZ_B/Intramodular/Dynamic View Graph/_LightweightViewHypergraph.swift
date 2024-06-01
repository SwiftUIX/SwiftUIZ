//
// Copyright (c) Vatsal Manot
//

import Compute
import Merge
import Swallow
import SwiftUIX
import _SwiftUIZ_A

@objc(_SwiftUIZ_type_LightweightViewHypergraph)
public final class _LightweightViewHypergraph: _AnyViewHypergraph, _AnyViewHypergraphType {
    package var initialStaticViewTypeDescriptors: IdentifierIndexingArrayOf<_StaticViewTypeDescriptor> = []
    package var nodes: IdentifierIndexingArray<any _AnyViewHypergraph.InterposeProtocol, _AnyViewHypergraph.InterposeID> = .init(id: \._opaque_id)
        
    public subscript(_ id: Interpose.ID) -> any _AnyViewHypergraph.InterposeProtocol {
        nodes[id: id]!
    }
    
    public func insert(_ object: any _AnyViewHypergraph.InterposeProtocol) {
        self.nodes.insert(object)
    }
    
    public func prepare(_ object: some _AnyViewHypergraph.InterposeProtocol) throws {
        
    }
    
    public func remove(_ object: any _AnyViewHypergraph.InterposeProtocol) {
        self.nodes.remove(object)
    }
}
