//
// Copyright (c) Vatsal Manot
//

import _DVGraph
import _SwiftUI_Internals
import SwiftUI

public class _DVViewBridge: _DVHierarchicalViewBridge {
    public var owner: _DVGraph?

    public var descriptor: _DVViewTypeDescriptor!
}

// MARK: - Conformances

extension _DVViewBridge: CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self) {
            [
                "descriptor": descriptor
            ]
        }
    }
}

// MARK: - Debug

public struct _DebugDynamicView: View {
    @_ViewBridge(_DVViewBridge.self) var bridge
    
    public var body: some View {
        _PrintMirrorView(reflecting: bridge)
            .border(Color.red)
            .frame(maxWidth: 512)
    }
    
    public init() {
        
    }
}
