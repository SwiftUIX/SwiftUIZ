//
// Copyright (c) Vatsal Manot
//

import Foundation

extension Sequence where Element == InlineNode {
    @_transparent
    func collect<Result>(
        _ c: (InlineNode) throws -> [Result]
    ) rethrows -> [Result] {
        try self.flatMap({ try $0.collect(c) })
    }
}

extension InlineNode {
    @_transparent
    func collect<Result>(
        _ c: (InlineNode) throws -> [Result]
    ) rethrows -> [Result] {
        try self.children.collect(c) + c(self)
    }
}
