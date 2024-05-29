//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public final class _ViewInterposeScope: CustomStringConvertible, Hashable {
    @inlinable
    public var description: String {
        String(hashValue, radix: 36, uppercase: false)
    }
    
    public init() {
        
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @inlinable
    public static func == (lhs: _ViewInterposeScope, rhs: _ViewInterposeScope) -> Bool {
        lhs === rhs
    }
}

@MainActor
public struct _SetViewInterposeScope<C: View>: _ThinViewModifier {
    @State private var scope = _ViewInterposeScope()
    
    public init() {
        
    }
    
    public func body(content: C) -> some View {
        content.transformEnvironment(\._opaque_interposeContext) { context in
            if let _context = context {
                assert(!_context._isInvalidInstance)
            }
            
            context?.scope = scope
        }
    }
}
