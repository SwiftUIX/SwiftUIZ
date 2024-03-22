//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import Combine
import Swallow
import SwiftUI

@propertyWrapper
public struct ViewContext: ViewGraphParticipant {
    @Environment(\._dynamicViewGraphContext) public var _dynamicViewGraphContext

    @State public private(set) var id = ViewGraphParticipantID()

    @Environment(\._dynamicViewAttributeGraphContext) private var _store: _DVConcreteAttributeGraphContext

    @StateObject private var subscriptionContainer = _DVConcreteAttributeSubscriptionGroup()

    private let location: SourceCodeLocation

    public init(
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        location = SourceCodeLocation(fileID: fileID, line: line, column: nil)
    }

    public var wrappedValue: _DVConcreteAttributeContext {
        _DVConcreteAttributeContext(
            store: _store,
            container: subscriptionContainer.wrapper(location: location),
            notifyUpdate: subscriptionContainer.objectWillChange.send
        )
    }
}

extension ViewGraphParticipant {
    public var node: ViewGraph.Node? {
        _dynamicViewGraphContext.inheritance.first(byUnwrapping: {
            _dynamicViewGraphContext.graph?[$0]
        })
    }
}
