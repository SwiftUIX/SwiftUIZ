/*//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol ChatAction: _ViewAction {
    
}

public protocol _SendMessageAction<Item>: _ViewAction {
    associatedtype Item
    
    var item: Item { get set }
}

extension _ViewActionGroups {
    public struct Chat: _ViewActionGroup {
        public init() {
            
        }
    }
}

extension _ViewActionGroup where Self == _ViewActionGroups.Chat {
    public static var chat: Self {
        Self()
    }
}

extension _ViewActionName<_ViewActionGroups.Chat, _SendMessageAction> {
    public static var sendMessage: Self {
        .init(base: (any _SendMessageAction).self)
    }
}

extension _ViewActionName where ActionGroupType == _ViewActionGroups.Chat {
    public static func sendMessage<Item>(
        _ item: Item.Type = Item.self
    ) -> Self where Self == _ViewActionName<ActionGroupType, any _SendMessageAction<Item>> {
        .init(base: (any _SendMessageAction<Item>).self)
    }
}

fileprivate struct Bar: View {
    var body: some View {
        EmptyView()
            .action(.sendMessage(Int.self), in: .chat) { action in
                print(action.item)
            } bind: {
                $0.item = 1
            }
    }
}

*/
