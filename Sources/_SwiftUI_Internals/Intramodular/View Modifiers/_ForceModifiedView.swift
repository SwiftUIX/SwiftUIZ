//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Swallow

public protocol _ForceModifiedView<ViewModifierType>: _AnyForceModifiedView, DynamicProperty, View {
    associatedtype ViewModifierType: Initiable & ViewModifier
    
    static var _viewModifier: ViewModifierType { get }
}

// MARK: - Implementation

extension _ForceModifiedView where ViewModifierType: ViewModifier {
    @usableFromInline
    typealias _ModifiedBody = ModifiedContent<_ForceModifiedViewBody<Self>, ViewModifierType>
    
    public static var _viewModifier: ViewModifierType {
        .init()
    }
    
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> SwiftUI._ViewOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        return _ModifiedBody._makeView(view: modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> SwiftUI._ViewListOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        return _ModifiedBody._makeViewList(view: modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: SwiftUI._ViewListCountInputs
    ) -> Int? {
        _ModifiedBody._viewListCount(inputs: inputs)
    }
}

// MARK: - Auxiliary

@usableFromInline
struct _ForceModifiedViewBody<Content: View>: View {
    @usableFromInline
    var content: Content
    
    @usableFromInline
    init(content: Content) {
        self.content = content
    }
    
    @usableFromInline
    var body: some View {
        LazyView {
            content.body
        }
    }
}

extension _ForceModifiedView {
    @usableFromInline
    subscript<T: Initiable & ViewModifier>(
        _lazilyModifiedBy body: Metatype<T.Type>
    ) -> ModifiedContent<_ForceModifiedViewBody<Self>, T> {
        get {
            ModifiedContent(content: _ForceModifiedViewBody(content: self), modifier: T())
        }
    }
}
