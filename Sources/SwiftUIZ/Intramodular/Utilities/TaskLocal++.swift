//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

extension TaskLocal {
    @MainActor
    public func _makeViewWithValue<Content: View>(
        _ value: Value,
        @ViewBuilder content: @MainActor () -> Content,
        start: @MainActor () -> Void,
        end: @MainActor () -> Void
    ) -> Content {
        start()
        
        let result = self.withValue(value) {
            content()
        }
        
        end()
        
        return result
    }
}
