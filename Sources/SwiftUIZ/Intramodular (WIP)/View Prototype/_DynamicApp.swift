//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicApp: App where Body: _DynamicAppScene {
    var body: Body { get }
}

extension _DynamicApp where Body == _DynamicApp_DefaultBody {
    public var body: _DynamicApp_DefaultBody {
        _DynamicApp_DefaultBody()
    }
}

public struct _DynamicApp_DefaultBody: _DynamicAppScene {
    public var body: some _DynamicAppScene {
        DiscoveredScenes()
    }
}
