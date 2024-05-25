//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Swallow

/// A type that vends shallow environment values for the immediate view that it is attached to.
@_spi(Internal)
public class _ShallowEnvironmentProvider {
    public struct EnvironmentKey: Hashable, Identifiable {
        public let id: AnyHashable
        public let key: PartialKeyPath<_ShallowEnvironmentValues.Keys>
    }
    
    public var storage: [EnvironmentKey: Any] = [:]
    
    public var isEmpty: Bool {
        storage.isEmpty
    }
    
    public subscript<T>(
        _ key: EnvironmentKey,
        as type: T.Type
    ) -> T? {
        get {
            #try(.optimistic) {
                try cast(storage[key], to: T.self)
            }
        }
    }
    
    public init() {
        
    }
    
    public func hydrate(
        from values: _ShallowEnvironmentValues,
        forSurface surface: _ShallowEnvironmentHydrationSurface
    ) {
        for key in surface.staticViewTypeDescriptor._shallowEnvironmentKeys {
            self.storage[EnvironmentKey(id: key.id, key: key.key)] = values.storage[key.key]!
        }
    }
}
