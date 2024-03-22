//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import UniformTypeIdentifiers

public struct _SwiftUIX_AnyPasteCommandDelegate {
    public var supportedContentTypes: [UTType]
    public var action: ([NSItemProvider]) -> Void
    
    public init(
        supportedContentTypes: [UTType],
        action: @escaping ([NSItemProvider]) -> Void
    ) {
        self.supportedContentTypes = supportedContentTypes
        self.action = action
    }
}
