//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import Swallow

extension Button: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Label == Never {
    public enum _StaticSwift_GenericTypeParameterName: _StaticSwift.GenericTypeParameterNameProtocol {
        case label
    }
}

extension Button: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.Button.self
    }
}

extension ForEach: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Data == AnyRandomAccessCollection<Never>, ID == Never, Content == Never {
    
}

extension ForEach: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.ForEach.self
    }
}

extension Form: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension Form: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.Form.self
    }
}

extension HStack: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension HStack: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.HStack.self
    }
}
  
extension LazyVStack: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension LazyVStack: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.LazyVStack.self
    }
}

extension Label: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Title == Never, Icon == Never {
    public enum _StaticSwift_GenericTypeParameterName: _StaticSwift.GenericTypeParameterNameProtocol {
        case title
        case icon
    }
}

extension Label: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.Label.self
    }
}

extension List: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where SelectionValue == Never, Content == Never {
    
}

extension List: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.List.self
    }
}

extension NavigationView: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension NavigationView: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.NavigationView.self
    }
}

extension NavigationStack: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Data == [NavigationPath], Root == Never {
    
}

extension NavigationStack: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.NavigationStack.self
    }
}

extension NavigationSplitView: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Sidebar == Never, Content == Never, Detail == Never {
    
}

extension NavigationSplitView: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.NavigationSplitView.self
    }
}

extension Picker: _StaticSwift_IsPlaceholderedVariantOfGenericType where Label == Never, SelectionValue == Never, Content == Never {
    
}

extension Picker: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf  {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.Picker.self
    }
}

extension ScrollView: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension ScrollView: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.ScrollView.self
    }
}

extension Text: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType {
    
}

extension Text: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.Text.self
    }
}

extension VStack: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension VStack: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.VStack.self
    }
}

extension ZStack: Swallow._StaticSwift_IsPlaceholderedVariantOfGenericType where Content == Never {
    
}

extension ZStack: Swallow._StaticSwift_HasPlaceholderedVariantOfGenericSelf {
    public static var _StaticSwift_replacingGenericTypeParametersWithPlaceholders: any _StaticSwift_IsPlaceholderedVariantOfGenericType.Type {
        SwiftUI.ZStack.self
    }
}
