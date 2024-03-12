//
// Copyright (c) Vatsal Manot
//

import Combine
import CorePersistence
import Expansions
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
    ) -> (some DynamicSceneContent)? {
        _expectNoThrow {
            try? _resolveDynamicSceneContent(for: .init(value: instance))
        }
    }
    
    internal func _resolveDynamicSceneContent(
        for parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) throws -> _AnyDynamicSceneContent? {
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

extension InterfaceModel {
    fileprivate func _opaque_attemptToResolve(
        from sceneManager: _DynamicSceneManager
    ) -> _AnyDynamicSceneContent? {
        if let content = try? sceneManager._resolveDynamicSceneContent(for: .init(value: id)) {
            return content
        } else if let content = try? sceneManager._resolveDynamicSceneContent(for: .init(id: id, value: self)) {
            return content
        } else {
            return nil
        }
    }
}
