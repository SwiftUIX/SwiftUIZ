//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public enum ViewGraphNodeStateFlag {
    case resolved
}

public typealias ViewGraphNodeState = Set<ViewGraphNodeStateFlag>

public protocol _DynamicViewGraphNodeType: AnyObject, HashEquatable, Identifiable where ID == _ViewGraphNodeID {
    var parent: Self? { get }
    var id: _ViewGraphNodeID { get }
    var elementProperties: [_ViewAttributeID: any _ConsumableDynamicViewElementProperty] { get set }
    var state: ViewGraphNodeState { get set }
    
    var staticViewTypeDescriptor: _StaticViewTypeDescriptor { get }
    var staticViewDescription: _ViewTypeDescription { get set }
    
    var swizzledViewBody: (any View)? { get }
    
    func update() throws
}

extension _DynamicViewGraphNodeType {
    public var _opaque_parent: (any _DynamicViewGraphNodeType)? {
        parent
    }

    public var _opaque_id: _ViewGraphNodeID {
        id
    }
}

extension _DynamicViewGraphNodeType {
    public var ancestorSequence: AnySequence<any _DynamicViewGraphNodeType> {
        AnySequence<any _DynamicViewGraphNodeType> {
            var start = self
            
            return AnyIterator<any _DynamicViewGraphNodeType> { () -> (any _DynamicViewGraphNodeType)? in
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

public typealias _ViewGraphNodeID = _AutoIncrementingIdentifier<any _DynamicViewGraphNodeType>
