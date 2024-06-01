//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _ExtendedApp: App where Body: _ExtendedScene {
    var body: Body { get }
}

// MARK: - Implementation

@MainActor
extension _ExtendedApp where Body == _ExtendedApp_DefaultBody {
    public var body: _ExtendedApp_DefaultBody {
        _ExtendedApp_DefaultBody()
    }
}

@MainActor
public struct _ExtendedApp_DefaultBody: _ExtendedScene {
    public var body: some _ExtendedScene {
        _RuntimeDiscoveredScenes()
    }
}
