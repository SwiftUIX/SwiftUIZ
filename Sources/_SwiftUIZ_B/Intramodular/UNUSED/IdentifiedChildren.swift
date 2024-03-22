//
// Copyright (c) Vatsal Manot
//

import _SwiftUIZ_A

public struct IdentifiedChildren<Content: View>: DynamicView {
    @Environment(\._parentView) var _parentView
    
    var taskLocalProxy = IdentityGroupProxy.current
    
    @_ViewParameter(IdentityGroupProxy.self)
    var parametrizedProxy: IdentityGroupProxy?
    
    var proxy: IdentityGroupProxy? {
        taskLocalProxy ?? parametrizedProxy
    }
    
    let content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        /*if proxy == nil {
         runtimeIssue(.unexpected)
         
         assertionFailure()
         }*/
        
        self.content = content
    }
    
    public init(
        _ proxy: IdentityGroupProxy,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.taskLocalProxy = proxy
        self.content = content
    }
    
    public var body: some View {
        if let proxy {
            if let resolver = proxy._resolver {
                content()
                    .modifier(_IndexAllIdentifiableChildren(resolver: resolver))
            } else {
                _UnimplementedView()
            }
        } else {
            _UnimplementedView()
        }
    }
}

struct _IndexAllIdentifiableChildren: ViewModifier {
    @Environment(\._parentView) var _parentView
    
    let resolver: _ViewIdentityResolver
    
    @State var delay: Bool = false
    
    @ViewStorage var lastCount: Int?
    @ViewStorage var resolvedCount: Int?
    
    func body(content: Content) -> some View {
        _VariadicViewAdapter(content) { content in
            let count: Int = content.children.count
            
            let _: Void = {
                if self.lastCount != count {
                    self.resolvedCount = nil
                    
                    DispatchQueue.main.async {
                        delay = true
                    }
                } else if self.resolvedCount == nil  {
                    self.resolvedCount = self.lastCount
                } else if delay {
                    self.resolvedCount = self.lastCount
                }
                
                self.lastCount = count
            }()
            
            _ForEachSubview(enumerating: content) { index, subview in
                subview.background {
                    ZeroSizeView()
                        .onAppear {
                            if delay {
                                delay = false
                            }
                            
                        }
                        .id(delay)
                }
            }
            
            let _: Void = resolve(with: content.children)
        }
    }
    
    @MainActor
    func resolve(with children: _VariadicViewChildren) {
        guard resolvedCount != nil && delay == false else {
            return
        }
        
        let identities = Set(children.compactMap({ $0[trait: \._viewIdentity]?.id }))
        
        guard !identities.isEmpty else {
            return
        }
        
        guard resolver.stateFlags.contains(.resolutionInProgress) else {
            resolver.setNeedsPass()
            
            return
        }
        
        resolver._resolution?.children.formUnion(Set(identities))
    }
}
