//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

struct _ViewIdentityConfiguration {
    
}

struct _ViewIdentityState: Hashable {
    var surfaceGeneration: Int = 0
    var generation: Int = 0
}

public struct _ViewIdentity {
    public struct Path: Hashable {
        @_HashableExistential
        public var type: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type
        
        public init<T: _SwiftUI_WithPlaceholderGenericTypeParameters>(
            _ type: T.Type
        ) {
            self.type = type
        }
    }
    
    public struct ID: Hashable {
        let rawValue: UUID
        
        public init() {
            self.rawValue = .init()
        }
    }
    
    let _unsafeProxy: IdentityGroupProxy
    let id: _ViewIdentity.ID
    let generation: Int
    var path: [Path]
    
    init(
        _unsafeProxy: IdentityGroupProxy,
        id: _ViewIdentity.ID,
        generation: Int,
        path: [Path]
    ) {
        self._unsafeProxy = _unsafeProxy
        self.id = id
        self.generation = generation
        self.path = path
    }
}

extension _ViewIdentity {
    struct Resolved: Hashable {
        var children: Set<ID>
    }
}

@_ViewTrait
public struct _ViewIdentityTrait: Hashable {
    let id: _ViewIdentity.ID
}

@_ViewTraitKey(for: _ViewIdentityTrait.self, named: "_viewIdentity")
extension _ViewTraitKeys {
    
}

extension EnvironmentValues {
    @EnvironmentValue var _parentView: _ViewIdentity?
}
