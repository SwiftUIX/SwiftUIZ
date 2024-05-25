//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwiftUIX

public protocol _DynamicViewGraphType: _AnyDynamicViewGraph {
    var _isInvalidInstance: Bool { get }
    
    subscript(_ id: _ViewGraphNodeID) -> any _DynamicViewGraphNodeType { get }
    
    func prepare(_ node: some _DynamicViewGraphNodeType) throws
    
    func insert(_ node: any _DynamicViewGraphNodeType)
    func remove(_ node: any _DynamicViewGraphNodeType)
    
    init()
}

public struct _ViewAttributeShape {
    public let type: Any.Type
    
    public init(type: Any.Type) {
        self.type = type
    }
}
