//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _ConsumableViewHypergraphElementProperty {
    static var _isHiddenConsumable: Bool { get }
    
    var _isConsumableResolved: Bool { get throws }
    
    @MainActor
    dynamic func __conversion(
        context: EnvironmentValues._opaque_InterposeContextProtocol
    ) throws -> any _ConsumableViewHypergraphElementProperty
    
    @MainActor
    func _resolveShallowIdentifier(
        in context: some EnvironmentValues._opaque_InterposeContextProtocol
    ) throws -> _ViewHyperpropertyID
    
    @MainActor
    func update<Context: EnvironmentValues._opaque_InterposeContextProtocol>(
        id: _ViewHyperpropertyID,
        context: inout Context
    ) throws
}

extension _ConsumableViewHypergraphElementProperty {
    public static var _isHiddenConsumable: Bool {
        false
    }
    
    public var _isConsumableResolved: Bool {
        true
    }
}
