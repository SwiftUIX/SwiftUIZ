//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwiftUI

open class _InterposedViewBodyBridgeProtocol: _HierarchicalViewBridge<_InterposedViewBodyBridgeProtocol> {
    
}

public class _InterposedViewBodyBridge: _InterposedViewBodyBridgeProtocol {
    package var _swiftType: any _DynamicView.Type
    
    package weak var _bodyStorage: _InterposedViewBodyStorage?
    
    public var bodyStorage: _InterposedViewBodyStorage {
        _bodyStorage!
    }
    
    @usableFromInline
    package init(_swiftType: any _DynamicView.Type, _bodyStorage: _InterposedViewBodyStorage?) {
        self._swiftType = _swiftType
        self._bodyStorage = _bodyStorage
        
        super.init()
    }
}

// MARK: - Conformances

extension _InterposedViewBodyBridge: CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self) {
            [
                "type": _swiftType
            ]
        }
    }
}

// MARK: - Debug

public struct _DebugInterposedViewBody: View {
    @_ViewBridge(_InterposedViewBodyBridge.self) var bridge
    
    public var body: some View {
        _PrintMirrorView(reflecting: bridge)
            .border(Color.red)
            .frame(maxWidth: 512)
    }
    
    public init() {
        
    }
}
