//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public protocol _DynamicViewGraphPass<Target> {
    associatedtype Target
}

public struct _DynamicViewGraphPassContext<Pass> {
    public init() {
        
    }
}

public protocol _DynamicViewGraphPassTarget {
    
}

public protocol _DynamicViewGraphPassUpdating {
    associatedtype SymbolType
    
    static func update<Target: _DynamicViewGraphPassTarget, Pass: _DynamicViewGraphPass>(
        _ target: inout Target,
        in pass: Pass,
        symbol: _DynamicViewSymbol<SymbolType>,
        context: _DynamicViewGraphPassContext<Pass>
    ) throws
}


extension _DynamicViewGraphPassUpdating {
    public static func _typeUnchecked_update<Target: _DynamicViewGraphPassTarget, Pass: _DynamicViewGraphPass>(
        _ target: inout Target,
        in pass: Pass,
        symbol: some _DynamicViewSymbolType,
        context: _DynamicViewGraphPassContext<Pass>
    ) throws {
        try self.update(&target, in: pass, symbol: unsafeBitCast(symbol), context: context)
    }
}
