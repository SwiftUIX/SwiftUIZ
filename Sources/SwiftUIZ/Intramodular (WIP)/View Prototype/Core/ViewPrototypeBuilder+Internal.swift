//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// Push a resolved `ViewPrototype`.
struct _ModifyViewPrototype: ViewPrototype {
    let operation: (inout _UnresolvedViewPrototypeGraph) -> Void
    
    init(_ operation: @escaping (inout _UnresolvedViewPrototypeGraph) -> Void) {
        self.operation = operation
    }
    
    var body: some View {
        transformPreference(_ViewPrototypePreferenceKey.self) { value in
            operation(&value.base)
        }
    }
}

/// Push a resolved `ViewPrototype`.
struct _PushViewPrototypeExpression: ViewPrototype {
    let prototype: _UnresolvedViewPrototype
    
    init(_ prototype: _UnresolvedViewPrototype) {
        self.prototype = prototype
    }
    
    init(_ prototype: () -> _UnresolvedViewPrototype) {
        self.prototype = prototype()
    }
    
    init(_ primitive: any _PrimitiveViewPrototype) {
        self.init(_UnresolvedViewPrototype(primitive))
    }
    
    var body: some View {
        ZeroSizeView().preference(
            key: _ViewPrototypePreferenceKey.self,
            value: .init() // FIXME
        )
    }
}
