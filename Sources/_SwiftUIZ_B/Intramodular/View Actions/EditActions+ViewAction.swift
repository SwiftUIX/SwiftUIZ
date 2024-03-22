//
// Copyright (c) Vatsal Manot
//

import SwiftUI

extension _ViewActionGroups {
    public struct EditActions: _ViewActionGroup {
        public init() {
            
        }
    }
}

extension _ViewActionName<_ViewActionGroups.EditActions, Any> {
    public static var delete: Self {
        .init(base: Any.self)
    }
}


extension _ViewActionGroups.EditActions {
    public typealias Delete = _ViewActionGroups_EditActions_Delete
    
    public struct DeleteItem<Item>: Delete {
        @Parameter var item: Item
        
        public init() {
            
        }
    }
}

public protocol _ViewActionGroups_EditActions_Delete: _ViewAction<_ViewActionGroups.EditActions> {
    
}
