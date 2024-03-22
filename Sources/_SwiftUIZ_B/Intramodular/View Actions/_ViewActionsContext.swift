//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

struct _ViewActionsContext: Hashable {
    struct _ViewActionConsumer: Identifiable {
        typealias ID = _TypeAssociatedID<Self, UUID>
        
        let id = ID()
    }
    
    var consumer: _ViewActionConsumer.ID?
    var knownTypes: Set<ViewActionTypeIdentifier> = []
    
    init() {
        
    }
}

extension EnvironmentValues {
    @EnvironmentValue
    var viewActionsContext = _ViewActionsContext()
}
