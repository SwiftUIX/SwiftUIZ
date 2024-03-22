//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import Merge
@_spi(Internal) import Swallow
import SwiftUI

public struct _UnsafelyConvertViewToViewPrototype<Content: View>: ViewPrototype {
    public let content: Content
    
    public init(content: Content) {
        self.content = content
    }
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
    }
}

extension ViewBuilder {
    @_disfavoredOverload
    public static func buildBlock() -> EmptyViewPrototype {
        EmptyViewPrototype()
    }

    @_disfavoredOverload
    public static func buildBlock<T: View>(
        _ view: T
    ) -> some ViewPrototype {
        _UnsafelyConvertViewToViewPrototype(content: view)
    }
}
