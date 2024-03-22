//
// Copyright (c) Vatsal Manot
//

import SwiftSyntax
import SwiftDiagnostics

enum MacroDiagnosticMessage: String, DiagnosticMessage {
    case noDefaultArgument
    case missingAnnotation
    case notAnIdentifier
    
    var severity: DiagnosticSeverity {
        return .error
    }
    
    var message: String {
        switch self {
            case .noDefaultArgument:
                "No default value provided."
            case .missingAnnotation:
                "No annotation provided."
            case .notAnIdentifier:
                "Identifier is not valid."
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "com.vmanot.SwiftUIZ", id: rawValue)
    }
}
