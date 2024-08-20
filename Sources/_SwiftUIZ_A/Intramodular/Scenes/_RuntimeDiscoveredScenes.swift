//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import Runtime
import Swallow
import SwiftUIX

/// Scenes discovered at runtime using `RuntimeDiscoveryIndex`.
public struct _RuntimeDiscoveredScenes: _ExtendedScene {
    @_StaticMirrorQuery(type: (any Scene).self)
    private static var allSceneTypes: [any Scene.Type]
    
    public init() {
        
    }
    
    public var body: some Scene {
        _DonateDynamicSceneInitializer {
            try! Self.allSceneTypes.flatMap { sceneType -> [_DynamicSceneInitializerGroup] in
                guard !(sceneType is any _SwiftUIZ_PrimitiveScene.Type) else {
                    return []
                }
                
                typealias InitiableScene = Initiable & Scene
                
                switch sceneType {
                    case Self.self:
                        return []
                    case Never.self:
                        return []
                    default:
                        break
                }
                
                guard let sceneType = sceneType as? any InitiableScene.Type else {                    
                    return []
                }
                
                let scene = sceneType.init()
                
                guard let _scene = scene.body as? any _SwiftUIZ_Scene else {
                    return []
                }
                
                return try _scene._resolve()
            }
        }
    }
}
