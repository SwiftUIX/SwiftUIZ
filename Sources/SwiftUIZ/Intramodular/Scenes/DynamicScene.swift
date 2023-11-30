//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _SwiftUIZ_MaybePrimitiveScene: Scene {
    var body: Body { get }
}

public protocol _SwiftUIZ_PrimitiveScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

public protocol DynamicScene: _SwiftUIZ_MaybePrimitiveScene where Body: _SwiftUIZ_MaybePrimitiveScene {
    var body: Body { get }
}

// MARK: - Implemented Conformances

public struct _SwiftUIZ_FakeScene: _SwiftUIZ_PrimitiveScene, DynamicScene {
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

public struct SceneThatMakesSense: _SwiftUIZ_PrimitiveScene, DynamicScene {
    private var content: [any Scene]
    
    public init(
        @ArrayBuilder content: () -> [any Scene]
    ) {
        self.content = content()
    }
    
    public var body: some DynamicScene {
        _SwiftUIZ_FakeScene {
            try! content.flatMap {
                try cast($0, to: (any DynamicScene).self)._resolve()
            }
        }
    }
}

extension DynamicScene {
    public func _resolve() throws -> [_DynamicSceneInitializerGroup] {
        if let _self = self as? _SwiftUIZ_FakeScene {
            return _self._resolve()
        } else if let body = body as? _SwiftUIZ_FakeScene {
            return body._resolve()
        } else {
            throw _PlaceholderError()
        }
    }
}

extension WindowGroup: _SwiftUIZ_MaybePrimitiveScene {
    
}
