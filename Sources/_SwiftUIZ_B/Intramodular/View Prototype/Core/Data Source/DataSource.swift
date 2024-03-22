//
// Copyright (c) Vatsal Manot
//

import Swallow

/// An abstract representation of a view's data source.
public protocol DataSource: View where Body: DataSource {
    var body: Body { get }
}

extension Never: DataSource {
    
}
