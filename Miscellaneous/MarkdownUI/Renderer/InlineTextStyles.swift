//
// Copyright (c) Vatsal Manot
//

import Foundation

@frozen
@usableFromInline
struct InlineTextStyles: Hashable {
    let code: AnyTextStyle
    let emphasis: AnyTextStyle
    let strong: AnyTextStyle
    let strikethrough: AnyTextStyle
    let link: AnyTextStyle
    
    init(
        code: any TextStyle,
        emphasis: any TextStyle,
        strong: any TextStyle,
        strikethrough: any TextStyle,
        link: any TextStyle
    ) {
        self.code = .init(erasing: code)
        self.emphasis = .init(erasing: emphasis)
        self.strong = .init(erasing: strong)
        self.strikethrough = .init(erasing: strikethrough)
        self.link = .init(erasing: link)
    }
}
