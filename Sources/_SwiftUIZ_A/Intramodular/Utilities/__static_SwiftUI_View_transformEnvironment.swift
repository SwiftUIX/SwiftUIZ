//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _SwiftUI_View_transformEnvironment<EnvironmentValueType> {
    associatedtype EnvironmentValueType
    
    var environmentKey: WritableKeyPath<EnvironmentValues, EnvironmentValueType> { get }
    
    func transformEnvironment<View: SwiftUI.View>(
        _ environment: inout EnvironmentValueType,
        for view: View
    )
}

public protocol __static_SwiftUI_View_transformEnvironment<EnvironmentValueType> {
    associatedtype EnvironmentValueType
    
    static var environmentKey: WritableKeyPath<EnvironmentValues, EnvironmentValueType> { get }
    
    static func transformEnvironment<View: SwiftUI.View>(
        _ view: View,
        transform: @escaping (inout EnvironmentValueType) -> Void
    )
}

extension _SwiftUIX_ViewModifiers {
    public struct _SwiftUI_View_transformEnvironment<T: _SwiftUIZ_A._SwiftUI_View_transformEnvironment>: ViewModifier {
        let transformEnvironment: T
        
        public func body(content: Content) -> some View {
            content.transformEnvironment(transformEnvironment.environmentKey) { environment in
                transformEnvironment.transformEnvironment(&environment, for: content)
            }
        }
    }
}
