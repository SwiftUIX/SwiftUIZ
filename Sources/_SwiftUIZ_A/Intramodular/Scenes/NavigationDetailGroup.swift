//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

/// A scene that represents a navigation detail.
@MainActor
public struct NavigationDetailGroup<Content: View>: _SwiftUIZ_Scene {
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
                    erasing: _DynamicSceneInitializers.ValueBased(value: { value -> _AnySceneContent? in
                        if validate(value) {
                            return _AnySceneContent {
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
    
    public var body: some _SwiftUIZ_Scene {
        _DonateDynamicSceneInitializer {
            initializer
        }
    }
}
