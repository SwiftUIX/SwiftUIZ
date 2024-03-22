//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

public protocol _SwiftUIZ_DynamicViewParameterKey<Value>: Hashable {
    associatedtype Value
}

public struct _SwiftUIZ_DynamicViewParameterKeys {
    
}

extension _SwiftUIZ_DynamicViewParameterKeys {
    public struct _TypeToParameterKeyAdaptor<T>: Hashable {
        public typealias Value = T
        
        public let type: Metatype<T>
    }
    
    public subscript<T>(_ type: Metatype<T>) -> _TypeToParameterKeyAdaptor<T> {
        .init(type: type)
    }
}
