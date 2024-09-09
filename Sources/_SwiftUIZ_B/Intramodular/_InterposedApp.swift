//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _InterposedApp: App where Body: _DynamicScene {
    var body: Body { get }
}

// MARK: - Implementation

@MainActor
extension _InterposedApp where Body == _InterposedApp_DefaultBody {
    public var body: _InterposedApp_DefaultBody {
        _InterposedApp_DefaultBody()
    }
}

@MainActor
public struct _InterposedApp_DefaultBody: _DynamicScene {
    public var body: some _DynamicScene {
        _RuntimeDiscoveredScenes()
    }
}
