//
// Copyright (c) Vatsal Manot
//

import _SwiftUIZ_A

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
    case navigation
    case navigationView
    case view
    case title
    case subtitle
    case heading
    case grid
    case collection
    case label
    case list
    case table
    case button
    case cell
    case accessoryBar
    case toolbar
    case contextMenu
    case menu
    case control
    case sourceList
    case multipleSelection
    case singleSelection
}
