//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicApp: App where Body: _DynamicAppScene {
    var body: Body { get }
}

// MARK: - Implementation

@MainActor
extension _DynamicApp where Body == _DynamicApp_DefaultBody {
    public var body: _DynamicApp_DefaultBody {
        _DynamicApp_DefaultBody()
    }
}

@MainActor
public struct _DynamicApp_DefaultBody: _DynamicAppScene {
    public var body: some _DynamicAppScene {
        _RuntimeDiscoveredScenes()
    }
}
