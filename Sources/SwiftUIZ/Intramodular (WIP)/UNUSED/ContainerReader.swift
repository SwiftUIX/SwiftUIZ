//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import Merge
@_spi(Internal) import Swallow
import SwiftUIX

public protocol ContainerProxyType: Initiable {
    associatedtype Kind: ContainerProxyKind
}

public struct ContainerProxy<Kind: ContainerProxyKind>: ContainerProxyType {
    public init() {
        
    }
}

public struct ContainerReader<Proxy: ContainerProxyType, Content: View>: View {
    let content: (Proxy) -> Content
    
    @State var proxy = Proxy()
    
    public init<Kind: ContainerProxyKind>(
        _ kind: Kind,
        @ViewBuilder content: @escaping (Proxy) -> Content
    ) where Kind.ProxyType == Proxy {
        self.content = content
    }
    
    public var body: some View {
        content(proxy)
    }
}

