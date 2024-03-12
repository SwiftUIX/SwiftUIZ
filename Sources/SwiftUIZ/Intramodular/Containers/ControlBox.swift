//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct ControlBox<Content: View>: View {
    public let content: Content
    
    @FocusState var isFocused: Bool
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .focused($isFocused)
            .padding(.small)
            .onTapGestureOnBackground {
                isFocused = true
            }
            .background(HierarchicalShapeStyle.quaternary)
            .cornerRadius(4)
    }
}
