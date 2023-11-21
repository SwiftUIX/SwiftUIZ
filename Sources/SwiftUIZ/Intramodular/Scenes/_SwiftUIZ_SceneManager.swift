//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import SwiftUIX

@Singleton
public final class _SwiftUIZ_SceneManager: ObservableObject {
    public var scenes: IdentifierIndexingArrayOf<_SceneInitializerGroup> = []
    
    func _register(_ scenes: [_SceneInitializerGroup]) {
        self.scenes.append(contentsOf: scenes)
    }
    
    func initializer(
        for parameters: _SwiftUIZ_AnySceneInitializerParameters
    ) throws -> (any _SceneInitializer)? {
        scenes.first(byUnwrapping: { group in
            group.initializers.first(where: {
                (try? $0.resolve(from: parameters)) != nil
            })
        })
    }
    
    internal func _resolveSceneContent(
        for parameters: _SwiftUIZ_AnySceneInitializerParameters
    ) throws -> _ResolvedSceneContent? {
        guard let initializer = try initializer(for: parameters) else {
            runtimeIssue("Failed to find a scene initializer.")
            
            return nil
        }
        
        guard let content = try initializer.resolve(from: parameters) else {
            runtimeIssue("Failed to initialize the scene content.")
            
            return nil
        }
        
        return content
    }
}
