//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

@MainActor
public struct _DVConcreteAttributeSubscription {
    let subscription: _DVConcreteAttributeSubscriptionGroup.ID
    let location: SourceCodeLocation
    let requiresObjectUpdate: Bool
    let notifyUpdate: () -> Void
    
    init(
        subscription: _DVConcreteAttributeSubscriptionGroup.ID,
        location: SourceCodeLocation,
        requiresObjectUpdate: Bool,
        notifyUpdate: @escaping () -> Void
    ) {
        self.subscription = subscription
        self.location = location
        self.requiresObjectUpdate = requiresObjectUpdate
        self.notifyUpdate = notifyUpdate
    }
}

@MainActor
public final class _DVConcreteAttributeSubscriptionGroup: Identifiable, ObservableObject {
    private var subscribers = Set<DVAttributeNodeID>()
    private var unsubscribe: ((Set<DVAttributeNodeID>) -> Void)?
    
    public let id = _DVConcreteAttributeSubscriptionGroup.ID()
    
    public nonisolated init() {
        
    }
    
    deinit {
        unsubscribe?(subscribers)
    }
}

extension _DVConcreteAttributeSubscriptionGroup {
    public class ID: Hashable {
        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }
        
        @inlinable
        public static func == (lhs: ID, rhs: ID) -> Bool {
            lhs === rhs
        }
    }
}

extension _DVConcreteAttributeSubscriptionGroup {
    @MainActor
    public struct Wrapper {
        private weak var container: _DVConcreteAttributeSubscriptionGroup?
        
        let key: _DVConcreteAttributeSubscriptionGroup.ID
        let location: SourceCodeLocation
        
        var subscribers: Set<DVAttributeNodeID> {
            get {
                container?.subscribers ?? []
            } nonmutating set {
                container?.subscribers = newValue
            }
        }
        
        var unsubscribe: ((Set<DVAttributeNodeID>) -> Void)? {
            get {
                container?.unsubscribe
            } nonmutating set {
                container?.unsubscribe = newValue
            }
        }
        
        init(
            _ container: _DVConcreteAttributeSubscriptionGroup,
            token: _DVConcreteAttributeSubscriptionGroup.ID,
            location: SourceCodeLocation
        ) {
            self.container = container
            self.key = token
            self.location = location
        }
    }
    
    public func wrapper(location: SourceCodeLocation) -> Wrapper {
        Wrapper(self, token: id, location: location)
    }
}
