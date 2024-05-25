//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A scene that represents a presentation.
public struct PresentationGroup<Content: View>: _SwiftUIZ_Scene {
    public let initializer: _DynamicSceneInitializerGroup
    
    public init(@ViewBuilder content: () -> Content) {
        self.initializer = _DynamicSceneInitializerGroup(
            id: Metatype(Self.self),
            initializers: [
                _AnyDynamicSceneInitializer(
                    erasing: _DynamicSceneInitializers.ResolvedContent(content: content())
                )
            ]
        )
    }
    
    public var body: some _SwiftUIZ_Scene {
        _DonateDynamicSceneInitializer {
            initializer
        }
    }
}
