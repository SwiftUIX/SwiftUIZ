//
// Copyright (c) Vatsal Manot
//

import SwiftUI

/// https://github.com/OpenSwiftUIProject/OpenSwiftUI
public struct _SwiftUI_BloomFilter: Equatable {
    public var value: UInt
    
    public init(hashValue: Int) {
        // Make sure we do LSR instead of ASR
        let value = UInt(hashValue)
       
        let a0 = 1 &<< (value &>> 0x10)
        let a1 = 1 &<< (value &>> 0xa)
        let a2 = 1 &<< (value &>> 0x4)
        
        self.value = a0 | a1 | a2
    }
    
    public init(type: Any.Type) {
        let pointer = unsafeBitCast(type, to: OpaquePointer.self)
      
        self.init(hashValue: Int(bitPattern: pointer))
    }
    
    @inline(__always)
    func match(_ filter: _SwiftUI_BloomFilter) -> Bool {
        (value & filter.value) == value
    }
}
