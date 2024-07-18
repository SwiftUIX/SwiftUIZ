//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol ModifiedContentProtocol<ContentType> {
    associatedtype ContentType
    
    var content: ContentType { get }
}

extension ModifiedContent: ModifiedContentProtocol {
    
}
