//
// Copyright (c) Vatsal Manot
//

import SwiftUI

extension EnvironmentValues {
    private struct BaseURLKey: EnvironmentKey {
        static var defaultValue: URL? = nil
    }
    
    var baseURL: URL? {
        get { self[BaseURLKey.self] }
        set { self[BaseURLKey.self] = newValue }
    }
    
    private struct ImageBaseURLKey: EnvironmentKey {
        static var defaultValue: URL? = nil
    }
    
    var imageBaseURL: URL? {
        get {
            self[ImageBaseURLKey.self]
        } set {
            self[ImageBaseURLKey.self] = newValue
        }
    }
}
