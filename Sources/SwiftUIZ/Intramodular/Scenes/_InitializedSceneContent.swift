//
// Copyright (c) Vatsal Manot
//

import Swallow

struct _InitializedSceneContent: View {
    @StateObject private var sceneManager: _SwiftUIZ_SceneManager = .shared
    
    @_LazyState var resolvedContent: _ResolvedSceneContent?
    
    init(
        parameters: _SwiftUIZ_AnySceneInitializerParameters
    ) {
        let sceneManager = _SwiftUIZ_SceneManager.shared
        
        self._resolvedContent = .init(
            wrappedValue: try! sceneManager._resolveSceneContent(for: parameters)
        )
    }
    
    public var body: some View {
        if let resolvedContent {
            resolvedContent
        } else {
            _UnimplementedView()
        }
    }
}
