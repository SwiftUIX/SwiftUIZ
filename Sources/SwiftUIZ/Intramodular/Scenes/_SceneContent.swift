//
// Copyright (c) Vatsal Manot
//

import FoundationX
import Swallow
import SwiftUIX

public protocol SceneContent: View {
    associatedtype Body
    
    var body: Body { get }
}

// MARK: - Implemented Conformances

public struct _AnySceneContent: SceneContent {
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

extension _AnySceneContent {
    private init<Document: InterfaceModel>(
        document: any _SwiftUIX_BindingType<Document>
    ) {
        self.init {
            _InitializeDynamicSceneContent(
                parameters: .init(
                    value: document
                )
            )
            .id(document.wrappedValue.id)
        }
    }
    
    public init<Document: InterfaceModel>(
        document: some _SwiftUIX_BindingType<Document>
    ) {
        self.init(document: document as (any _SwiftUIX_BindingType<Document>))
    }
    
    public init<Document: InterfaceModel>(
        document: Binding<Document>
    ) {
        self.init(document: document as (any _SwiftUIX_BindingType<Document>))
    }
}
