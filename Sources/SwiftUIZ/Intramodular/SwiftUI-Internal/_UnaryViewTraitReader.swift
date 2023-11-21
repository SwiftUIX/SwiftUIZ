//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

public struct _UnaryViewTraitReader<Key: _ViewTraitKey, Content: View>: View where Key.Value: Equatable {
    let key: Key.Type
    let content: Content
    let action: (Key.Value) -> Void
    
    public init<T>(
        _ type: T.Type,
        @ViewBuilder content: () -> Content,
        action: @escaping (Key.Value) -> Void
    ) where Key == _TypeToViewTraitKeyAdaptor<T> {
        self.key =  _TypeToViewTraitKeyAdaptor<T>.self
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        _VariadicViewAdapter(self.content) { content in
            let _: Void = _validate(content.children)
            
            if let view = content.children.first {
                let trait = view[key]
                let _: Void = action(trait)
                
                view
            }
        }
    }
    
    private func _validate(_ children: _VariadicViewChildren) {
        guard children.count == 1 else {
            runtimeIssue("_UnaryViewTraitReader expected to read a single view, but got: \(children.count)")
            
            return
        }
    }
}
