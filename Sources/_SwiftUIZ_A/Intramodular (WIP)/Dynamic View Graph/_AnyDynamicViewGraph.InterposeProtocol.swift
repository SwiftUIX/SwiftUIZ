//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public enum ViewGraphNodeStateFlag {
    case resolved
}

public typealias ViewGraphNodeState = Set<ViewGraphNodeStateFlag>

extension _AnyDynamicViewGraph {
    public typealias InterposeID = _AutoIncrementingIdentifier<any _AnyDynamicViewGraph.InterposeProtocol>

    public protocol InterposeProtocol: AnyObject, HashEquatable, Identifiable where ID == _AnyDynamicViewGraph.InterposeID {
        var parent: Self? { get }
        var id: _AnyDynamicViewGraph.InterposeID { get }
        var elementProperties: [_ViewAttributeID: any _ConsumableDynamicViewGraphElementProperty] { get set }
        var state: ViewGraphNodeState { get set }
        
        var staticViewTypeDescriptor: _StaticViewTypeDescriptor { get }
        var staticViewDescription: _ViewTypeDescription { get set }
        
        var swizzledViewBody: (any View)? { get }
        
        func update() throws
    }
}

extension _AnyDynamicViewGraph.InterposeProtocol {
    public var _opaque_parent: (any _AnyDynamicViewGraph.InterposeProtocol)? {
        parent
    }

    public var _opaque_id: _AnyDynamicViewGraph.InterposeID {
        id
    }
}

extension _AnyDynamicViewGraph.InterposeProtocol {
    public var ancestorSequence: AnySequence<any _AnyDynamicViewGraph.InterposeProtocol> {
        AnySequence<any _AnyDynamicViewGraph.InterposeProtocol> {
            var start = self
            
            return AnyIterator<any _AnyDynamicViewGraph.InterposeProtocol> { () -> (any _AnyDynamicViewGraph.InterposeProtocol)? in
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
