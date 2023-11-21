//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public protocol ChatAction: _ViewAction {
    
}

public protocol _SendMessageAction<Item>: _ViewAction {
    associatedtype Item
    
    var item: AnyHashable { get }
}

extension _ViewActionName where ActionGroupType == _ViewActionGroups.Chat, ActionType == any _SendMessageAction {
    public static var sendMessage: Self {
        .init(base: (any _SendMessageAction).self)
    }
}

extension _ViewActionGroups {
    public struct Chat: _ViewActionGroup {
        
    }
}

extension _ViewActionGroup where Self == _ViewActionGroups.Chat {
    public static var chat: Self {
        Self()
    }
}

fileprivate struct Bar: View {
    var body: some View {
        EmptyView()
            .actions(for: .chat) {
                ViewAction(.sendMessage) {
                    
                }
            }
    }
}

