//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _ConsumableDynamicViewGraphElementProperty {
    static var _isHiddenConsumableDynamicViewElementProperty: Bool { get }
    
    var _isAttributeResolved: Bool { get throws }
    
    @MainActor
    dynamic func __conversion(
        context: EnvironmentValues._opaque_InterposeContextProtocol
    ) throws -> any _ConsumableDynamicViewGraphElementProperty
    
    @MainActor
    func _resolveShallowIdentifier(
        in context: some EnvironmentValues._opaque_InterposeContextProtocol
    ) throws -> _ViewAttributeID
    
    @MainActor
    func update<Context: EnvironmentValues._opaque_InterposeContextProtocol>(
        id: _ViewAttributeID,
        context: inout Context
    ) throws
}

extension _ConsumableDynamicViewGraphElementProperty {
    public static var _isHiddenConsumableDynamicViewElementProperty: Bool {
        false
    }
    
    public var _isAttributeResolved: Bool {
        true
    }
}
