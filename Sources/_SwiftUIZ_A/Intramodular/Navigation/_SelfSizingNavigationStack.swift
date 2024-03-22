//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _SelfSizingNavigationStack<Content: View>: View {
    private enum _ViewElement {
        case content
    }
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        FrameReader { proxy in
            NavigationStack {
                Group {
                    content
                        ._scrollBounceBehaviorBasedOnSizeIfAvailable()
                        .frame(id: _ViewElement.content)
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
            .frame(width: proxy.size(for: _ViewElement.content)?.width)
            .frame(
                minHeight: proxy.size(for: _ViewElement.content).map({ $0.height + 44 }),
                idealHeight: proxy.size(for: _ViewElement.content).map({ $0.height + 44 })
            )
        }
    }
}
