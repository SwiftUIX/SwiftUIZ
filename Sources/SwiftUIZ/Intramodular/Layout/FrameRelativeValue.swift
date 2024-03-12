//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

@MainActor
public struct FrameRelativeValue<Value> {
    public let value: @MainActor (CGSize) -> Value
    
    public init(_ value: @escaping @MainActor @Sendable (CGSize) -> Value) {
        self.value = value
    }
    
    public init() where Value == CGFloat {
        self.value = { _ in 0 }
    }
}

extension FrameRelativeValue where Value == CGFloat {
    public static var width: Self {
        Self({ $0.width })
    }
    
    public static var height: Self {
        Self({ $0.height })
    }
}

extension View {
    public func relativeOffset(
        x: FrameRelativeValue<CGFloat>
    ) -> some View {
        self
    }
}

extension CGSize {
    @MainActor
    public func resolve(
        width: FrameRelativeValue<CGFloat>,
        height: FrameRelativeValue<CGFloat>
    ) -> CGSize {
        return CGSize(
            width: width.value(self),
            height: height.value(self)
        )
    }
}
