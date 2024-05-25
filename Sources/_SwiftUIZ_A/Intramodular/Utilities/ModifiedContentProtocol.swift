//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol ModifiedContentProtocol<Content> {
    associatedtype Content
    
    var content: Content { get }
}

extension ModifiedContent: ModifiedContentProtocol {
    
}
