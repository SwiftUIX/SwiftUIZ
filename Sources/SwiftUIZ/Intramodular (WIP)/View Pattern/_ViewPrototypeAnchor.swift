//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public enum _ViewPrototypeAnchor: Hashable {
    public enum KeywordExpression: Hashable {
        case keyword(_ViewPrototypeAnchorKeyword)
    }
    
    case keyword(KeywordExpression)
    case swiftUI(_SwiftUI_TypePlaceholder)
    
    public static func keyword(_ keyword: _ViewPrototypeAnchorKeyword) -> Self {
        Self.keyword(.keyword(keyword))
    }
}

public enum _ViewPrototypeAnchorKeyword: Hashable {
    case button
    case label
    case navigation
    case navigationView
    case view
}
