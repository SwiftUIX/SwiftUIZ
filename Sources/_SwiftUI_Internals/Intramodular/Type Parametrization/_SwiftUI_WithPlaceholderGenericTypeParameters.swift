//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public protocol _SwiftUI_EnumForGenericSwiftTypeParameter: Hashable {
    
}

public protocol _SwiftUI_WithPlaceholderGenericTypeParameters {
    associatedtype _SwiftUI_GenericParameterTypeName: _SwiftUI_EnumForGenericSwiftTypeParameter = Never
}

public protocol _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type { get }
}

// MARK: - Implemented Conformances

extension Never: _SwiftUI_EnumForGenericSwiftTypeParameter {
    
}

// MARK: - Supplementary

public struct _SwiftUI_TypePlaceholder: CustomStringConvertible, Hashable {
    @_HashableExistential
    public var type: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type
    @_HashableExistential
    public var parameter: (any _SwiftUI_EnumForGenericSwiftTypeParameter)?
    
    public var description: String {
        String(describing: type) + (parameter.map({ " " + String(describing: $0) }) ?? "")
    }
    
    public init<T: _SwiftUI_WithPlaceholderGenericTypeParameters>(
        type: T.Type,
        parameter: T._SwiftUI_GenericParameterTypeName?
    ) {
        self.type = type
        self.parameter = parameter
    }
}
