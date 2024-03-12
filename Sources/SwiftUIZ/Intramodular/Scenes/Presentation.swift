//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A scene that represents a presentation.
public struct Presentation<Content: View>: DynamicScene {
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
    
    public var body: some DynamicScene {
        _SwiftUIZ_DonateSceneInitializer {
            initializer
        }
    }
}
