//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _SwiftUI_WithPlaceholderGenericTypeParameters {
    associatedtype _SwiftUI_GenericParameterTypeName: Hashable = Never
}

public protocol _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type { get }
}
