//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

public struct _SwiftUIX_FocusInteractions: Hashable, OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let activate = Self(rawValue: 1 << 0)
    public static let edit = Self(rawValue: 1 << 1)
}
