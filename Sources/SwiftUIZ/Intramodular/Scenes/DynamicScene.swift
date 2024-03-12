//
// Copyright (c) Vatsal Manot
//

import Expansions
import SwiftUI

@MainActor
public protocol _SwiftUIZ_MaybePrimitiveScene: Scene {
    var body: Body { get }
}

@MainActor
public protocol _SwiftUIZ_PrimitiveScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

@MainActor
public protocol DynamicScene: _SwiftUIZ_MaybePrimitiveScene where Body: _SwiftUIZ_MaybePrimitiveScene {
    var body: Body { get }
}

// MARK: - Implemented Conformances

@MainActor
public struct _SwiftUIZ_DonateSceneInitializer: _SwiftUIZ_PrimitiveScene, DynamicScene {
    let content: () -> [_DynamicSceneInitializerGroup]
    
    public init(content: @escaping () -> [_DynamicSceneInitializerGroup]) {
        self.content = content
    }
    
    public init(content: @escaping () -> _DynamicSceneInitializerGroup) {
        self.init(content: { [content()] })
    }
    
    public var body: some _SwiftUIZ_MaybePrimitiveScene {
        _ = {
            _DynamicSceneManager.shared._register(content())
        }()
        
        return WindowGroup(id: UUID().uuidString) {
            ZeroSizeView()
        }
    }
    
    func _resolve() -> [_DynamicSceneInitializerGroup] {
        content()
    }
}

@MainActor
public struct SceneThatMakesSense: _SwiftUIZ_PrimitiveScene, DynamicScene {
    private var content: [any Scene]
    
    public init(
        @ArrayBuilder content: () -> [any Scene]
    ) {
        self.content = content()
    }
    
    public var body: some DynamicScene {
        _SwiftUIZ_DonateSceneInitializer {
            try! content.flatMap {
                try cast($0, to: (any DynamicScene).self)._resolve()
            }
        }
    }
}

@MainActor
extension DynamicScene {
    public func _resolve() throws -> [_DynamicSceneInitializerGroup] {
        if let _self = self as? _SwiftUIZ_DonateSceneInitializer {
            return _self._resolve()
        } else if let body = body as? _SwiftUIZ_DonateSceneInitializer {
            return body._resolve()
        } else {
            throw _PlaceholderError()
        }
    }
}

extension WindowGroup: _SwiftUIZ_MaybePrimitiveScene {
    
}
