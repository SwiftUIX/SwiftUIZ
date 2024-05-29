//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public struct _ViewPrototypeID: CustomStringConvertible, Sendable {
    private let base = _AutoIncrementingIdentifier<Self>()
    
    public var description: String {
        "#" + base.rawValue.description
    }
    
    public init() {
        
    }
}

extension _ViewPrototypeID: IdentifierProtocol {
    public var body: some IdentityRepresentation {
        base
    }
}
