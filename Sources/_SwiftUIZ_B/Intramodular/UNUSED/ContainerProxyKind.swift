//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import Merge
@_spi(Internal) import Swallow
import SwiftUIX

public protocol ContainerProxyKind {
    associatedtype ProxyType: ContainerProxyType
}

@_StaticProtocolMember(named: "parent", type: ContainerProxyKinds.Parent.self)
extension ContainerProxyKind where Self == ContainerProxyKinds.Parent {
    
}

@_StaticProtocolMember(named: "child", type: ContainerProxyKinds.Child.self)
extension ContainerProxyKind where Self == ContainerProxyKinds.Child {
    
}

public enum ContainerProxyKinds {
    public struct Parent: ContainerProxyKind {
        public typealias ProxyType = ContainerProxy<Self> // FIXME
    }
    
    public struct Child: ContainerProxyKind {
        public typealias ProxyType = ContainerProxy<Self> // FIXME
    }
}
