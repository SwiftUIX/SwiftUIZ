//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _DynamicViewDemand: Hashable {
    
}

public struct _DynamicViewDemands {
    public struct EnvironmentValue: _DynamicViewDemand {
        public var environmentValue: PartialKeyPath<EnvironmentValues>
    }
    
    public struct Trait: _DynamicViewDemand {
        @_HashableExistential
        public var value: any _ViewTraitKey.Type
    }
}
