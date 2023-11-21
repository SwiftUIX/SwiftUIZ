//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A scene that represents a presentation.
public struct Presentation<Content: View>: _SwiftUIZ_Scene {
    public let initializer: _SceneInitializerGroup
    
    public init(@ViewBuilder content: () -> Content) {
        self.initializer = _SceneInitializerGroup(
            id: Metatype(Self.self),
            initializers: [
                _AnySceneInitializer(
                    erasing: _SceneInitializers.ResolvedContent(content: content())
                )
            ]
        )
    }
    
    public var body: some _SwiftUIZ_Scene {
        _SwiftUIZ_FakeScene {
            initializer
        }
    }
}
