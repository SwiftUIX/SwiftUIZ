//
// Copyright (c) Vatsal Manot
//

import Swallow

package struct _Initialize_SceneContent: View {
    @StateObject private var sceneManager: _DynamicSceneManager = .shared
    
    @_LazyState private var _resolvedContent: _AnySceneContent?
    
    init(
        _resolvedContent: _AnySceneContent
    ) {
        __resolvedContent = .init(wrappedValue: _resolvedContent)
    }
    
    public init(
        parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) {
        let sceneManager = _DynamicSceneManager.shared
        
        self.__resolvedContent = .init(
            wrappedValue: try! sceneManager._resolve_SceneContent(for: parameters)
        )
    }
    
    public var body: some View {
        if let _resolvedContent {
            _resolvedContent
        } else {
            _UnimplementedView()
        }
    }
}
