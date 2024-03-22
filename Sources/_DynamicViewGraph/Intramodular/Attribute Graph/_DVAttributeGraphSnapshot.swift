//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _DVAttributeGraphSnapshot: CustomStringConvertible {
    public let structureDescription: _DVConcreteAttributeGraph.StructureDescription
    public let caches: [DVAttributeNodeID: any _DVAttributeNodeCache]
    public let subscriptions: [DVAttributeNodeID: [_DVConcreteAttributeSubscriptionGroup.ID: _DVConcreteAttributeSubscription]]

    public init(
        structureDescription: _DVConcreteAttributeGraph.StructureDescription,
        caches: [DVAttributeNodeID: any _DVAttributeNodeCache],
        subscriptions: [DVAttributeNodeID: [_DVConcreteAttributeSubscriptionGroup.ID: _DVConcreteAttributeSubscription]]
    ) {
        self.structureDescription = structureDescription
        self.caches = caches
        self.subscriptions = subscriptions
    }

    public var description: String {
        """
        Snapshot
        - graph: \(structureDescription)
        - caches: \(caches)
        """
    }

    @MainActor
    public func lookup<Node: _DVConcreteAttribute>(_ attribute: Node) -> Node.AttributeEvaluator.Value? {
        let key = DVAttributeNodeID(attribute, overrideScopeKey: nil)
        let cache = caches[key] as? _DVConcreteAttributeCache<Node>
        return cache?.value
    }
}

private extension String {
    var quoted: String {
        "\"\(self)\""
    }
}
