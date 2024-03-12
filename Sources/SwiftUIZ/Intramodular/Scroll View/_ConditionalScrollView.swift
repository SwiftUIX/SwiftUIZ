//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _ConditionalScrollView<Content: View>: View {
    public let scrollEnabled: Bool
    public let content: Content
    
    public init(
        scrollEnabled: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.scrollEnabled = scrollEnabled
        self.content = content()
    }
    
    public var body: some View {
        if !scrollEnabled {
            content
        } else {
            ScrollView(showsIndicators: true) {
                content
            }
            ._scrollBounceBehaviorBasedOnSizeIfAvailable()
        }
    }
}
