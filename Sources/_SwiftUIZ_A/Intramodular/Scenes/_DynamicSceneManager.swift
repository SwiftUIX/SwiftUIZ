//
// Copyright (c) Vatsal Manot
//

import Combine
import CorePersistence
import SwiftUIX

@Singleton
public final class _DynamicSceneManager: ObservableObject {
    @Published public var scenes: IdentifierIndexingArrayOf<_DynamicSceneInitializerGroup> = []
    
    func _register(_ scenes: [_DynamicSceneInitializerGroup]) {
        self.scenes.append(contentsOf: scenes)
    }
    
    func initializer(
        for parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) throws -> (any _DynamicSceneInitializer)? {
        scenes.first(byUnwrapping: { group in
            group.initializers.first(where: {
                (try? $0.resolve(from: parameters)) != nil
            })
        })
    }
    
    public func resolveContent<T>(
        for instance: T
    ) -> (some _SceneContent)? {
        #try(.optimistic) {
            try self._resolve_SceneContent(for: .init(value: instance))
        }
    }
    
    package func _resolve_SceneContent(
        for parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) throws -> _AnySceneContent? {
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
