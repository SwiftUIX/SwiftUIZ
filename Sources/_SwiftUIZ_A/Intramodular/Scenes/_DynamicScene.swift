//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

extension Scene {
    public func hidden() -> some _DynamicScene {
        SwiftUI._EmptyScene()
    }
}

extension SwiftUI._EmptyScene: _DynamicScene {
    public var body: Never {
        fatalError()
    }
}
