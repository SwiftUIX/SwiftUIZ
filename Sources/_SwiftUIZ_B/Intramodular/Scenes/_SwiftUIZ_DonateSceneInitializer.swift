//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public struct _SwiftUIZ_DonateSceneInitializer: _SwiftUIZ_PrimitiveScene, _SwiftUIZ_Scene {
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
