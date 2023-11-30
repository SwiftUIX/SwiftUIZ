//
// Copyright (c) Vatsal Manot
//

import Swallow

@_spi(Internal)
public struct _InitializeDynamicSceneContent: View {
    @StateObject private var sceneManager: _DynamicSceneManager = .shared
    
    @_LazyState private var resolvedContent: _AnySceneContent?
    
    public init(
        parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) {
        let sceneManager = _DynamicSceneManager.shared
        
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
