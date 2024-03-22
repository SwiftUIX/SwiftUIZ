//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct EmptyViewPrototype: ViewPrototype {
    public var body: some View {
        _UnsafelyConvertViewToViewPrototype {
            EmptyView()
        }
    }
    
    public init() {
        
    }
}
