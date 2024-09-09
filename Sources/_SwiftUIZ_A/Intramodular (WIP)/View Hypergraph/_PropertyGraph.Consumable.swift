//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public enum _PropertyGraph {
    
}

extension _PropertyGraph {
    public protocol Consumable {
        static var _isHiddenConsumable: Bool { get }
        
        var _isConsumableResolved: Bool { get throws }
        
        dynamic func __conversion(
            context: EnvironmentValues._opaque_InterposeGraphContextProtocol
        ) throws -> any _PropertyGraph.Consumable
        
        func _resolveShallowIdentifier(
            in context: some EnvironmentValues._opaque_InterposeGraphContextProtocol
        ) throws -> _PGElementID
        
        func update<Context: EnvironmentValues._opaque_InterposeGraphContextProtocol>(
            id: _PGElementID,
            context: inout Context
        ) throws
    }
}

extension _PropertyGraph.Consumable {
    public static var _isHiddenConsumable: Bool {
        false
    }
    
    public var _isConsumableResolved: Bool {
        true
    }
}
