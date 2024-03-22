//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol InterfaceModel: Identifiable where ID: InterfaceModelIdentifier {
    
}

public protocol InterfaceModelIdentifier: InterfaceModel, Hashable, Sendable where ID == Self {
    associatedtype Model: InterfaceModel
}

// MARK: - Supplementary

extension _AnySceneContent {
    private init<Document: InterfaceModel>(
        document: any _SwiftUIX_BindingType<Document>
    ) {
        self.init {
            _Initialize_SceneContent(
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

extension InterfaceModel {
    fileprivate func _opaque_attemptToResolve(
        from sceneManager: _DynamicSceneManager
    ) -> _AnySceneContent? {
        if let content = try? sceneManager._resolve_SceneContent(for: .init(value: id)) {
            return content
        } else if let content = try? sceneManager._resolve_SceneContent(for: .init(id: id, value: self)) {
            return content
        } else {
            return nil
        }
    }
}
// MARK: - Implemented Conformances

extension _TypeAssociatedID: InterfaceModel where Parent: InterfaceModel {
    
}

extension _TypeAssociatedID: InterfaceModelIdentifier where Parent: InterfaceModel {
    public typealias Model = Parent
}
