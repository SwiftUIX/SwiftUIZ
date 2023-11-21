//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow
import SwiftUIX

public struct DocumentEditor<Document, Content: View>: _SwiftUIZ_Scene {
    private let initializer: _SceneInitializerGroup
    
    public var body: some _SwiftUIZ_Scene {
        _SwiftUIZ_FakeScene {
            initializer
        }
    }
    
    fileprivate init(initializer: _SceneInitializerGroup) {
        self.initializer = initializer
    }
}

extension DocumentEditor {
    public init(
        newDocument: @escaping () -> Document,
        @ViewBuilder editor: @escaping (_FileDocumentConfiguration<Document>) -> Content
    ) {
        self.initializer = _SceneInitializerGroup(id: Metatype(Self.self)) {
            _AnySceneInitializer(
                erasing: _SceneInitializers.DocumentEditor(
                    newDocument: newDocument,
                    content: editor
                )
            )
        }
    }
    
    public init(
        newDocument: @autoclosure @escaping () -> Document,
        @ViewBuilder editor: @escaping (_FileDocumentConfiguration<Document>) -> Content
    ) {
        self.init(
            newDocument: newDocument,
            editor: editor
        )
    }
    
    public init(
        newDocument: @escaping () -> Document,
        @ViewBuilder editor: @escaping (_ReferenceFileDocumentConfiguration<Document>) -> Content
    ) where Document: ObservableObject {
        self.initializer = _SceneInitializerGroup(id: Metatype(Self.self)) {
            _AnySceneInitializer(
                erasing: _SceneInitializers.ReferenceDocumentEditor(
                    newDocument: newDocument,
                    content: editor
                )
            )
        }
    }
    
    public init(
        newDocument: @autoclosure @escaping () -> Document,
        @ViewBuilder editor: @escaping (_ReferenceFileDocumentConfiguration<Document>) -> Content
    ) where Document: ObservableObject {
        self.init(
            newDocument: newDocument,
            editor: editor
        )
    }
}
