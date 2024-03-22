//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

struct _ViewPrototypePreferenceKey: PreferenceKey {
    static var defaultValue: Value {
        Value()
    }
    
    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value.mergeInPlace(with: nextValue())
    }
}

extension _ViewPrototypePreferenceKey {
    struct Value: Initiable {
        var base: _UnresolvedViewPrototypeGraph
        
        init(base: _UnresolvedViewPrototypeGraph) {
            self.base = base
        }
        
        init() {
            self.init(base: .init())
        }
        
        mutating func mergeInPlace(with other: Self) {
            base.mergeInPlace(with: other.base)
        }
    }
}
