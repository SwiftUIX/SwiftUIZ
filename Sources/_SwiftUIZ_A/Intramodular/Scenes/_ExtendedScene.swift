//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _ExtendedScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

extension Scene {
    public func hidden() -> some _ExtendedScene {
        SwiftUI._EmptyScene()
    }
}

extension SwiftUI._EmptyScene: _ExtendedScene {
    public var body: Never {
        fatalError()
    }
}
