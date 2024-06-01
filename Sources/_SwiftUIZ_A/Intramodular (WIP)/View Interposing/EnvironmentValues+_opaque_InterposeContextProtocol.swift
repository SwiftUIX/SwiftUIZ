//
// Copyright (c) Vatsal Manot
//

import SwiftUI

extension EnvironmentValues {
    public protocol _opaque_InterposeContextProtocol {
        var _isInvalidInstance: Bool { get set }
        
        var scope: _ViewInterposeScope { get set }
        var _opaque_dynamicViewGraph: _AnyViewHypergraph? { get set }
    }
}

extension EnvironmentValues {
    public var _opaque_interposeContext: (any EnvironmentValues._opaque_InterposeContextProtocol)? {
        get {
            __unsafe_EnvironmentValues_opaque_interposeContext_getter(self)
        } set {
            __unsafe_EnvironmentValues_opaque_interposeContext_setter(&self, newValue)
        }
    }
}
