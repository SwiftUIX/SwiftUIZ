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

extension InlineNode {
    var children: [InlineNode] {
        get {
            switch self {
                case .emphasis(let children):
                    return children
                case .strong(let children):
                    return children
                case .strikethrough(let children):
                    return children
                case .link(_, let children):
                    return children
                case .image(_, let children):
                    return children
                default:
                    return []
            }
        }
        
        set {
            switch self {
                case .emphasis:
                    self = .emphasis(children: newValue)
                case .strong:
                    self = .strong(children: newValue)
                case .strikethrough:
                    self = .strikethrough(children: newValue)
                case .link(let destination, _):
                    self = .link(destination: destination, children: newValue)
                case .image(let source, _):
                    self = .image(source: source, children: newValue)
                default:
                    break
            }
        }
    }
}
