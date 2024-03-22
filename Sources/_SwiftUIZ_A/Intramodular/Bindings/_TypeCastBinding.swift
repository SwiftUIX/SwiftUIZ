//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _TypeCastBindingProxy<T> {
    var binding: Binding<T>
        
    public func `as`<U, Content: View>(
        _ type: U.Type,
        @ViewBuilder content: @escaping (Binding<U>) -> Content
    ) -> _WithTypeCastBinding<T, U, Content> {
        _WithTypeCastBinding(base: self, content: content)
    }
}

public struct _TypeCastBinding<T, Content: View>: View {
    public let binding: Binding<T>
    public let content: Content
    
    public init(_ binding: Binding<T>, @ViewBuilder content: (_TypeCastBindingProxy<T>) -> Content) {
        self.binding = binding
        self.content = content(.init(binding: binding))
    }
    
    public var body: some View {
        _VariadicViewAdapter(content) { content in
            content.children.first(where: { $0[_WithTypeCastBindingTrait.self] != nil })
        }
    }
}

public struct _WithTypeCastBinding<T, U, Content: View>: View {
    var base: _TypeCastBindingProxy<T>
    let content: (Binding<U>) -> Content
    
    public var body: some View {
        let binding = base.binding._conditionalCast(to: U.self)
        
        if binding.wrappedValue != nil {
            content(binding.forceUnwrap())
                .trait(_WithTypeCastBindingTrait())
        }
    }
}

// MARK: - Auxiliary

fileprivate struct _WithTypeCastBindingTrait: Hashable {
    
}
