//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

public struct _SwiftUIX_ViewTraitsReader<Content: View>: View {
    let content: (_SwiftUIX_ViewTraitValues) -> Content
    
    public init(@ViewBuilder content: @escaping (_SwiftUIX_ViewTraitValues) -> Content) {
        self.content = content
    }
    
    @ViewStorage var traits: _SwiftUIX_ViewTraitValues = .init()
    
    public var body: some View {
        _VariadicViewAdapter(self.content(traits)) { content in
            let _: Void = _validate(content.children)
            
            if let view = content.children.first {
                let _: Void = {
                    traits = view[_SwiftUIX_ViewTraitValues._ViewTraitKey.self]
                }()
                
                self.content(traits)
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
