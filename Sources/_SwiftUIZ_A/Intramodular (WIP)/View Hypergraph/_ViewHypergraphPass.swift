//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public protocol _HeavyweightViewHypergraphPass<Target> {
    associatedtype Target
}

public struct _HeavyweightViewHypergraphPassContext<Pass> {
    public init() {
        
    }
}

public protocol _HeavyweightViewHypergraphPassTarget {
    
}

public protocol _HeavyweightViewHypergraphPassUpdating {
    associatedtype SymbolType
    
    static func update<Target: _HeavyweightViewHypergraphPassTarget, Pass: _HeavyweightViewHypergraphPass>(
        _ target: inout Target,
        in pass: Pass,
        symbol: _AnyViewHypergraph.Symbol<SymbolType>,
        context: _HeavyweightViewHypergraphPassContext<Pass>
    ) throws
}


extension _HeavyweightViewHypergraphPassUpdating {
    public static func _typeUnchecked_update<Target: _HeavyweightViewHypergraphPassTarget, Pass: _HeavyweightViewHypergraphPass>(
        _ target: inout Target,
        in pass: Pass,
        symbol: some _AnyViewHypergraph.SymbolType,
        context: _HeavyweightViewHypergraphPassContext<Pass>
    ) throws {
        try self.update(&target, in: pass, symbol: unsafeBitCast(symbol), context: context)
    }
}
