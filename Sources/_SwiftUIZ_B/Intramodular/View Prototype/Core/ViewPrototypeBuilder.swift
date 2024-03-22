//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

@resultBuilder
public struct ViewPrototypeBuilder {
    @_transparent
    public static func buildBlock<T: ViewPrototype>(
        _ component: T
    ) -> T {
        component
    }
    
    @_transparent
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> _UnsafelyConvertViewToViewPrototype<TupleView<(repeat each Content)>> where repeat each Content: ViewPrototype {
        let prototype: _UnsafelyConvertViewToViewPrototype<TupleView<(repeat each Content)>>
        
        prototype = _UnsafelyConvertViewToViewPrototype(content: TupleView((repeat each content)))
        
        return prototype
    }
    
    @_transparent
    public static func buildPartialBlock<T: ViewPrototype>(
        _ component: T
    ) -> T {
        component
    }
    
    @_transparent
    public static func buildPartialBlock<each Content>(
        _ content: repeat each Content
    ) -> _UnsafelyConvertViewToViewPrototype<TupleView<(repeat each Content)>> where repeat each Content: ViewPrototype {
        buildBlock(repeat each content)
    }
}
