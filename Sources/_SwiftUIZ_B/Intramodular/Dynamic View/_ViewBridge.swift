//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import _SwiftUI_Internals
import SwiftUI

public class _DynamicViewBridge: _DynamicViewBridgeProtocol {
    public var owner: ViewGraph?

    package var descriptor: ViewTypeDescriptor!
}

// MARK: - Conformances

extension _DynamicViewBridge: CustomReflectable {
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
    @_ViewBridge(_DynamicViewBridge.self) var bridge
    
    public var body: some View {
        _PrintMirrorView(reflecting: bridge)
            .border(Color.red)
            .frame(maxWidth: 512)
    }
    
    public init() {
        
    }
}
