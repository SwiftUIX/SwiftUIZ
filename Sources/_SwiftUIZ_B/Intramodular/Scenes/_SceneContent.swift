//
// Copyright (c) Vatsal Manot
//

import FoundationX
import Swallow
import SwiftUIX

public protocol _SceneContent: View {
    associatedtype Body
    
    var body: Body { get }
}

// MARK: - Implemented Conformances

public struct _AnySceneContent: _SceneContent {
    public let content: () -> AnyView
    
    public init(content: @escaping () -> AnyView) {
        self.content = content
    }
    
    public init<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = { content().eraseToAnyView() }
    }
    
    public init<Content: View>(content: Content) {
        self.content = { content.eraseToAnyView() }
    }
    
    public var body: some View {
        content()
    }
}
