//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import Swallow

extension Button: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Label == Never {
    public enum _StaticSwift_GenericTypeParameterName: _StaticSwift.GenericTypeParameterNameProtocol {
        case label
    }
}

extension Button: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.Button.self
    }
}

extension ForEach: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Data == AnyRandomAccessCollection<Never>, ID == Never, Content == Never {
    
}

extension ForEach: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.ForEach.self
    }
}

extension Form: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension Form: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.Form.self
    }
}

extension HStack: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension HStack: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.HStack.self
    }
}
  
extension LazyVStack: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension LazyVStack: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.LazyVStack.self
    }
}

extension Label: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Title == Never, Icon == Never {
    public enum _StaticSwift_GenericTypeParameterName: _StaticSwift.GenericTypeParameterNameProtocol {
        case title
        case icon
    }
}

extension Label: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.Label.self
    }
}

extension List: _StaticSwift_CanHavePlaceholderGenericTypeParameters where SelectionValue == Never, Content == Never {
    
}

extension List: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.List.self
    }
}

extension NavigationView: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension NavigationView: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationView.self
    }
}

extension NavigationStack: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Data == [NavigationPath], Root == Never {
    
}

extension NavigationStack: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationStack.self
    }
}

extension NavigationSplitView: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Sidebar == Never, Content == Never, Detail == Never {
    
}

extension NavigationSplitView: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.NavigationSplitView.self
    }
}

extension Picker: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Label == Never, SelectionValue == Never, Content == Never {
    
}

extension Picker: _StaticSwift_HasPlaceholderedGenericTypeParameters  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.Picker.self
    }
}

extension ScrollView: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension ScrollView: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.ScrollView.self
    }
}

extension Text: _StaticSwift_CanHavePlaceholderGenericTypeParameters {
    
}

extension Text: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.Text.self
    }
}

extension VStack: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension VStack: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.VStack.self
    }
}

extension ZStack: _StaticSwift_CanHavePlaceholderGenericTypeParameters where Content == Never {
    
}

extension ZStack: _StaticSwift_HasPlaceholderedGenericTypeParameters {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_CanHavePlaceholderGenericTypeParameters.Type {
        SwiftUI.ZStack.self
    }
}
