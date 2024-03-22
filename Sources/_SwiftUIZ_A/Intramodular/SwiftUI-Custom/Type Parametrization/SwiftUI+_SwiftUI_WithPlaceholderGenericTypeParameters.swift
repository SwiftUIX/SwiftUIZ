//
// Copyright (c) Vatsal Manot
//

import SwiftUI

extension Button: _SwiftUI_WithPlaceholderGenericTypeParameters where Label == Never {
    public enum _SwiftUI_GenericParameterTypeName: _SwiftUI_EnumForGenericSwiftTypeParameter {
        case label
    }
}

extension Button: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.Button.self
    }
}

extension ForEach: _SwiftUI_WithPlaceholderGenericTypeParameters where Data == AnyRandomAccessCollection<Never>, ID == Never, Content == Never {
    
}

extension ForEach: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.ForEach.self
    }
}

extension Form: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension Form: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.Form.self
    }
}

extension HStack: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension HStack: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.HStack.self
    }
}
  
extension LazyVStack: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension LazyVStack: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.LazyVStack.self
    }
}

extension Label: _SwiftUI_WithPlaceholderGenericTypeParameters where Title == Never, Icon == Never {
    public enum _SwiftUI_GenericParameterTypeName: _SwiftUI_EnumForGenericSwiftTypeParameter {
        case title
        case icon
    }
}

extension Label: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.Label.self
    }
}

extension List: _SwiftUI_WithPlaceholderGenericTypeParameters where SelectionValue == Never, Content == Never {
    
}

extension List: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.List.self
    }
}

extension NavigationView: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension NavigationView: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationView.self
    }
}

extension NavigationStack: _SwiftUI_WithPlaceholderGenericTypeParameters where Data == [NavigationPath], Root == Never {
    
}

extension NavigationStack: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationStack.self
    }
}

extension NavigationSplitView: _SwiftUI_WithPlaceholderGenericTypeParameters where Sidebar == Never, Content == Never, Detail == Never {
    
}

extension NavigationSplitView: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationSplitView.self
    }
}

extension Picker: _SwiftUI_WithPlaceholderGenericTypeParameters where Label == Never, SelectionValue == Never, Content == Never {
    
}

extension Picker: _SwiftUI_HasPlaceholdersForGenericTypeParameters  {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.Picker.self
    }
}

extension ScrollView: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension ScrollView: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.ScrollView.self
    }
}

extension Text: _SwiftUI_WithPlaceholderGenericTypeParameters {
    
}

extension Text: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.Text.self
    }
}

extension VStack: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension VStack: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.VStack.self
    }
}

extension ZStack: _SwiftUI_WithPlaceholderGenericTypeParameters where Content == Never {
    
}

extension ZStack: _SwiftUI_HasPlaceholdersForGenericTypeParameters {
    public static var _SwiftUI_genericTypeParametersPlaceholdered: any _SwiftUI_WithPlaceholderGenericTypeParameters.Type {
        SwiftUI.ZStack.self
    }
}
