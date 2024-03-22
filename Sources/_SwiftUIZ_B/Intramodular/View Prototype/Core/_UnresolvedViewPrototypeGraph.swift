//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

struct _UnresolvedViewPrototypeGraph {
    var demands = _ExistentialSet<any _UnresolvedViewDemand>()
    var constraints = ViewPrototypeConstraints()
    
    public init() {
        
    }
    
    mutating func mergeInPlace(with other: Self) {
        fatalError()
    }
    
    public mutating func merge(_ anchor: _ViewPrototypeAnchor) {
        fatalError()
    }
    
    public mutating func merge(_ anchor: any _UnresolvedViewDemand) {
        demands.insert(anchor)
    }
}
