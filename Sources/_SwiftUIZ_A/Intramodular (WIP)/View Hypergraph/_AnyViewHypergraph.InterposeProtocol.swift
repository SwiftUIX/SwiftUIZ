//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public enum ViewInterpositionStateFlag {
    case resolved
}

public typealias ViewInterpositionState = Set<ViewInterpositionStateFlag>

extension _AnyViewHypergraph {
    public typealias InterposeID = _AutoIncrementingIdentifier<any _AnyViewHypergraph.InterposeProtocol>

    public protocol InterposeProtocol: AnyObject, HashEquatable, Identifiable where ID == _AnyViewHypergraph.InterposeID {
        var parent: Self? { get }
        var id: _AnyViewHypergraph.InterposeID { get }
        var elementProperties: [_PGElementID: any _PropertyGraph.Consumable] { get set }
        var state: ViewInterpositionState { get set }
        
        var staticViewTypeDescriptor: _StaticViewTypeDescriptor { get }
        var staticViewDescription: _ViewTypeDescription { get set }
        
        var swizzledViewBody: (any View)? { get }
        
        func update() throws
    }
}

extension _AnyViewHypergraph.InterposeProtocol {
    public var _opaque_parent: (any _AnyViewHypergraph.InterposeProtocol)? {
        parent
    }

    public var _opaque_id: _AnyViewHypergraph.InterposeID {
        id
    }
}

extension _AnyViewHypergraph.InterposeProtocol {
    public var ancestorSequence: AnySequence<any _AnyViewHypergraph.InterposeProtocol> {
        AnySequence<any _AnyViewHypergraph.InterposeProtocol> {
            var start = self
            
            return AnyIterator<any _AnyViewHypergraph.InterposeProtocol> { () -> (any _AnyViewHypergraph.InterposeProtocol)? in
                if let parent = start.parent {
                    start = parent
                    
                    return parent
                } else {
                    return nil
                }
            }
        }
    }
}
