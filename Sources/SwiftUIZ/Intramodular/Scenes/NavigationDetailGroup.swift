//
// Copyright (c) Vatsal Manot
//

import SwiftUI

/// A scene that represents a navigation detail.
@MainActor
public struct NavigationDetailGroup<Content: View>: DynamicScene {
    public let initializer: _DynamicSceneInitializerGroup
    
    public init<Value>(
        for type: Value.Type,
        @ViewBuilder content: @escaping (Value) -> Content,
        validate: @escaping (Value) -> Bool
    ) {
        self.initializer = _DynamicSceneInitializerGroup(
            id: Metatype(Self.self),
            initializers: [
                _AnyDynamicSceneInitializer(
                    erasing: _DynamicSceneInitializers.ValueBased(value: { value -> _AnyDynamicSceneContent? in
                        if validate(value) {
                            return _AnyDynamicSceneContent {
                                content(value)
                            }
                        } else {
                            return nil
                        }
                    })
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
