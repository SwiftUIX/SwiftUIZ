//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Swallow

public protocol _ThinForceModifiedView<ViewModifierType>: DynamicProperty, View {
    associatedtype ViewModifierType: Initiable
    
    static var _viewModifier: ViewModifierType { get }
}

public protocol _ForceModifiedView<ViewModifierType>: DynamicProperty, View {
    associatedtype ViewModifierType: Initiable & ViewModifier
    
    static var _viewModifier: ViewModifierType { get }
}

// MARK: - Implementation

extension _ThinForceModifiedView where ViewModifierType: _ThinViewModifier<Body> {
    @usableFromInline
    typealias _ThinModifiedBody = _RecursiveThinModifiedView<Self, ViewModifierType>
    
    public static var _viewModifier: ViewModifierType {
        .init()
    }
    
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        _ThinModifiedBody._viewListCount(inputs: inputs)
    }
}

extension _ThinForceModifiedView where ViewModifierType: _ThinForceViewModifier<Self, Body> {
    @usableFromInline
    typealias _ThinForceModifiedBody = _RecursiveThinForceModifiedView<Self, ViewModifierType>
    
    public static var _viewModifier: ViewModifierType {
        .init()
    }
    
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinForceModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinForceModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        _ThinForceModifiedBody._viewListCount(inputs: inputs)
    }
}

extension _ForceModifiedView where ViewModifierType: ViewModifier {
    @usableFromInline
    typealias _ModifiedBody = ModifiedContent<_ForceModifiedViewBody<Self>, ViewModifierType>
    
    public static var _viewModifier: ViewModifierType {
        .init()
    }
    
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        let keyPath: KeyPath<Self, _ModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
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

extension _ThinForceModifiedView {
    @usableFromInline
    subscript<T: Initiable & _ThinViewModifier>(
        _lazilyModifiedBy body: Metatype<T.Type>
    ) -> _RecursiveThinModifiedView<Self, T> {
        get {
            _RecursiveThinModifiedView(content: self, modifier: T())
        }
    }
    
    @usableFromInline
    subscript<T: Initiable & _ThinForceViewModifier>(
        _lazilyModifiedBy body: Metatype<T.Type>
    ) -> _RecursiveThinForceModifiedView<Self, T> {
        get {
            _RecursiveThinForceModifiedView(content: self, modifier: T())
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


@usableFromInline
struct _RecursiveThinModifiedView<Content: View, Modifier: _ThinViewModifier<Content.Body>>: View {
    public let content: Content
    public let modifier: Modifier
    
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    public var body: some View {
        modifier.body(content: content.body)
    }
}

@usableFromInline
struct _RecursiveThinForceModifiedView<Content: View, Modifier: _ThinForceViewModifier<Content, Content.Body>>: View {
    public let content: Content
    public let modifier: Modifier
    
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    public var body: some View {
        modifier.body(root: content, content: content.body)
    }
}

package enum _ForceModifiedView_TaskLocalValues {
    @TaskLocal package static var root: (any View)?
}
