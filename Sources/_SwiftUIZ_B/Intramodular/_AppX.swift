//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _AppX: App where Body: _SceneX {
    var body: Body { get }
}

// MARK: - Implementation

@MainActor
extension _AppX where Body == _AppX_DefaultBody {
    public var body: _AppX_DefaultBody {
        _AppX_DefaultBody()
    }
}

@MainActor
public struct _AppX_DefaultBody: _SceneX {
    public var body: some _SceneX {
        _RuntimeDiscoveredScenes()
    }
}
