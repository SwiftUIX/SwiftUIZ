//
// Copyright (c) Vatsal Manot
//

import SwiftUI

private struct _FocusOnAppear: ViewModifier {
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content.focused($isFocused).onAppear {
            isFocused = true

            withAnimation(after: .milliseconds(50)) {
                isFocused = true
            }
        }
    }
}

private struct _AddFocusActivatingBackground<Background: View>: ViewModifier {
    @FocusState private var isFocused: Bool
    
    let background: Background
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .background {
                background.onTapGesture {
                    isFocused = true
                }
            }
    }
}

// MARK: - API

extension View {
    /// Set the focus state of this view when it appears.
    public func _focusOnAppear() -> some View {
        modifier(_FocusOnAppear())
    }
    
    public func _focusActivatingBackground<V: View>(
        @ViewBuilder content: () -> V
    ) -> some View {
        modifier(_AddFocusActivatingBackground(background: content()))
    }
}
