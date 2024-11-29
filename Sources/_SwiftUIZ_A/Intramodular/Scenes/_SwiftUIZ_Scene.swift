//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public protocol _SwiftUIZ_MaybePrimitiveScene: Scene {
    var body: Body { get }
}

@MainActor
public protocol _SwiftUIZ_PrimitiveScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

@MainActor
public protocol _SwiftUIZ_Scene: _SwiftUIZ_MaybePrimitiveScene where Body: _SwiftUIZ_MaybePrimitiveScene {
    var body: Body { get }
}

// MARK: - Conformees

@MainActor
public struct SceneThatMakesSense: _SwiftUIZ_PrimitiveScene, _SwiftUIZ_Scene {
    private var content: [any Scene]
    
    public init(
        @ArrayBuilder content: () -> [any Scene]
    ) {
        self.content = content()
    }
    
    public var body: some _SwiftUIZ_Scene {
        _DonateDynamicSceneInitializer {
            try! content.flatMap {
                try cast($0, to: (any _SwiftUIZ_Scene).self)._resolve()
            }
        }
    }
}

@MainActor
extension _SwiftUIZ_Scene {
    public func _resolve() throws -> [_DynamicSceneInitializerGroup] {
        if let _self = self as? _DonateDynamicSceneInitializer {
            return _self._resolve()
        } else if let body = body as? _DonateDynamicSceneInitializer {
            return body._resolve()
        } else {
            throw _PlaceholderError()
        }
    }
}

#if os(macOS)
extension Window: _SwiftUIZ_MaybePrimitiveScene {
    
}
#endif

extension WindowGroup: _SwiftUIZ_MaybePrimitiveScene {
    
}
