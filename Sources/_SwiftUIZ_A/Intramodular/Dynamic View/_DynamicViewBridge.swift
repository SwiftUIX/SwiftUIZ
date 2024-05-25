//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwiftUI

open class _DynamicViewBridgeProtocol: _HierarchicalViewBridge<_DynamicViewBridgeProtocol> {
    
}

open class _DynamicViewSceneBridge: _DynamicViewBridgeProtocol {
    
}

public class _DynamicViewBridge: _DynamicViewBridgeProtocol {
    package var _swiftType: any _DynamicView.Type
    
    package weak var _bodyStorage: _DynamicViewBodyStorage?
    
    public var bodyStorage: _DynamicViewBodyStorage {
        _bodyStorage!
    }
    
    @usableFromInline
    package init(_swiftType: any _DynamicView.Type, _bodyStorage: _DynamicViewBodyStorage?) {
        self._swiftType = _swiftType
        self._bodyStorage = _bodyStorage
        
        super.init()
    }
}

// MARK: - Conformances

extension _DynamicViewBridge: CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self) {
            [
                "type": _swiftType
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
