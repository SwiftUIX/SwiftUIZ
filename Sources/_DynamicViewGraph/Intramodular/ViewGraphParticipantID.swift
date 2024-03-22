//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct ViewGraphParticipantID: Hashable, @unchecked Sendable {
    private let base = _AutoIncrementingIdentifier<Self>()
    
    public init() {
        
    }
}
