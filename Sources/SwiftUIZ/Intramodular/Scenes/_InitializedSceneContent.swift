//
// Copyright (c) Vatsal Manot
//

import Swallow

@_spi(Internal)
public struct _InitializeDynamicSceneContent: View {
    @StateObject private var sceneManager: _DynamicSceneManager = .shared
    
    @_LazyState private var _resolvedContent: _AnyDynamicSceneContent?
    
    init(
        _resolvedContent: _AnyDynamicSceneContent
    ) {
        __resolvedContent = .init(wrappedValue: _resolvedContent)
    }
    
    public init(
        parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) {
        let sceneManager = _DynamicSceneManager.shared
        
        self.__resolvedContent = .init(
            wrappedValue: try! sceneManager._resolveDynamicSceneContent(for: parameters)
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
