//
// Copyright (c) Vatsal Manot
//

@_exported import Swallow
@_exported import SwallowMacrosClient
@_exported import _SwiftUIZ_A

extension _TaskLocalValues {
    public struct _DynamicViewGraph {
        struct _DynamicViewBodyModifier {
            let root: Any.Type
            let content: Any.Type
        }
        
        var _managedDynamicViewBodyModifier: _DynamicViewBodyModifier?
    }
    
    @TaskLocal package static var _dynamicViewGraph = _DynamicViewGraph()
}
