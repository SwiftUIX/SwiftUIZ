//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _ForceModifiedView<ViewModifierType>: DynamicProperty, View {
    associatedtype ViewModifierType: Initiable & ViewModifier
}

extension _ForceModifiedView {
    @usableFromInline
    typealias _ModifiedBody = ModifiedContent<_ForceModifiedViewBody<Self>, ViewModifierType>
    
    @_transparent
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    @_transparent
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @_transparent
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        _ModifiedBody._viewListCount(inputs: inputs)
    }
}

// MARK: - Auxiliary

@usableFromInline
struct _ForceModifiedViewBody<Content: _ForceModifiedView>: View {
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
        @_transparent
        get {
            ModifiedContent(content: _ForceModifiedViewBody(content: self), modifier: T())
        }
    }
}
