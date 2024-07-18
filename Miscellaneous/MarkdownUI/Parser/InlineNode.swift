//
// Copyright (c) Vatsal Manot
//

import Foundation

public enum InlineNode: Hashable {
    case text(String)
    case softBreak
    case lineBreak
    case code(String)
    case html(String)
    case emphasis(children: [InlineNode])
    case strong(children: [InlineNode])
    case strikethrough(children: [InlineNode])
    case link(destination: String, children: [InlineNode])
    case image(source: String, children: [InlineNode])
}

