//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import Runtime
import Swallow
import SwiftUIX

/// Scenes discovered at runtime using `RuntimeDiscoverableTypes`.
public struct DiscoveredScenes: Scene {
    @RuntimeDiscoveredTypes(type: (any Scene).self)
    
    private static var discoveredScenes: [any Scene.Type]
    
    public init() {
        
    }
    
    public var body: some Scene {
        _SwiftUIZ_DonateSceneInitializer {
            try! Self.discoveredScenes.flatMap { sceneType -> [_DynamicSceneInitializerGroup] in
                guard !(sceneType is any _SwiftUIZ_PrimitiveScene.Type) else {
                    return []
                }
                
                typealias InitiableScene = Initiable & Scene
                
                switch sceneType {
                    case Self.self:
                        return []
                    default:
                        break
                }
                
                guard let sceneType = sceneType as? any InitiableScene.Type else {
                    assertionFailure()
                    
                    return []
                }
                
                let scene = sceneType.init()
                
                guard let _scene = scene.body as? any DynamicScene else {
                    assertionFailure()
                    
                    return []
                }
                
                return try _scene._resolve()
            }
        }
    }
}
