//
// Copyright (c) Vatsal Manot
//

import Combine
import CorePersistence
import Swallow
import SwiftUIX

public struct DocumentEditor<Document, Content: View>: _SwiftUIZ_Scene {
    private let initializer: _DynamicSceneInitializerGroup
    
    public var body: some _SwiftUIZ_Scene {
        _SwiftUIZ_DonateSceneInitializer {
            initializer
        }
    }
    
    fileprivate init(initializer: _DynamicSceneInitializerGroup) {
        self.initializer = initializer
    }
}

extension DocumentEditor {
    public init(
        newDocument: @escaping () -> Document,
        @ViewBuilder editor: @escaping (_FileDocumentConfiguration<Document>) -> Content
    ) {
        self.initializer = _DynamicSceneInitializerGroup(id: Metatype(Self.self)) {
            _AnyDynamicSceneInitializer(
                erasing: _DynamicSceneInitializers.DocumentEditor(
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
        self.initializer = _DynamicSceneInitializerGroup(id: Metatype(Self.self)) {
            _AnyDynamicSceneInitializer(
                erasing: _DynamicSceneInitializers.ReferenceDocumentEditor(
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
