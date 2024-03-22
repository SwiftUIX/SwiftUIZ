//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _UnresolvedViewPrototype {
    public struct Payload {
        public let primitive: any _PrimitiveViewPrototype
    }
    
    public var anchor: _ViewPrototypeAnchor?
    public var payload: _UnresolvedViewPrototype.Payload?
    
    public init(
        anchor: _ViewPrototypeAnchor?,
        payload: _UnresolvedViewPrototype.Payload?
    ) {
        self.anchor = anchor
        self.payload = payload
    }
}

extension _UnresolvedViewPrototype {
    public init(_ primitive: any _PrimitiveViewPrototype) {
        self.anchor = nil
        self.payload = .init(primitive: primitive)
    }
}

extension _UnresolvedViewPrototype {
    // FIXME: Why the fuck?
    public init() {
        self.init(anchor: nil, payload: nil)
    }
}

struct ViewPrototypeConstraints: Hashable {
    
}
