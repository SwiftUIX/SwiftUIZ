//
// Copyright (c) Vatsal Manot
//

import Swallow
@_exported import _SwiftUIZ_A

extension _TaskLocalValues {
    public struct _HeavyweightViewHypergraph {
        struct _InterposeViewBody {
            let root: Any.Type
            let content: Any.Type
        }
        
        var _managedDynamicViewBodyModifier: _InterposeViewBody?
    }
    
    @TaskLocal package static var _dynamicViewGraph = _HeavyweightViewHypergraph()
}
