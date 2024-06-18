//
// Copyright (c) Vatsal Manot
//

import Swallow

public enum _ViewInterposeError: CustomStringConvertible, Swift.Error, LocalizedError {
    case viewGraphMissing
    
    public var description: String {
        switch self {
            case .viewGraphMissing:
                return "`WindowGroup` needs to be rewritten as `WindowGroup(.dynamic)`"
        }
    }
    
    public var errorDescription: String? {
        description
    }
    
    public var recoverySuggestion: String? {
        switch self {
            case .viewGraphMissing:
                return "In your SwiftUI app declaration, try changing WindowGroup { ... } to WindowGroup(.dynamic) { ... }"
        }
    }
}
