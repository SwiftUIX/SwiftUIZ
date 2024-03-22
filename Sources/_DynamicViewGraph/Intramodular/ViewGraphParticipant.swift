//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol ViewGraphParticipant: DynamicProperty, Identifiable {
    var _dynamicViewGraphContext: ViewGraphEnvironmentContext { get }
    
    var id: ViewGraphParticipantID { get }
    
    func enterAssociation(with _: ViewGraph.Node)
    func exitAssociation(with _: ViewGraph.Node)
}

extension ViewGraphParticipant {
    public var node: ViewGraph.Node? {
        _dynamicViewGraphContext.inheritedNodes.first(where: { $0.associatedItems.contains(.init(from: self)) })
    }
    
    public func enterAssociation(with other: ViewGraph.Node) {
        
    }
    
    public func exitAssociation(with other: ViewGraph.Node) {
        
    }
}
