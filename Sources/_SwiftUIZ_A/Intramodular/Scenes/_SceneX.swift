//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _SceneX: _SwiftUIZ_MaybePrimitiveScene {
    
}

extension Scene {
    public func hidden() -> some _SceneX {
        SwiftUI._EmptyScene()
    }
}

extension SwiftUI._EmptyScene: _SceneX {
    public var body: Never {
        fatalError()
    }
}
