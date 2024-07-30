//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Swallow

public protocol _AnyForceModifiedView: DynamicProperty, View {
    static var _disableForceModifiedViewModification: Bool { get }
}

extension _AnyForceModifiedView {
    public static var _disableForceModifiedViewModification: Bool {
        false
    }
    
    fileprivate var _disableApplicationOfForceViewModifier: Bool {
        Self._disableForceModifiedViewModification
    }
}

fileprivate struct _AnyUnmodifiedView<Base: DynamicProperty & View>: View {
    var base: Base
    
    var body: some View {
        base.body
    }
    
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        let body: _GraphValue<Base.Body> = view[\Self.base.body]
        
        return Base.Body._makeView(view: body, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        let body: _GraphValue<Base.Body> = view[\Self.base.body]
        
        return Base.Body._makeViewList(view: body, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        Base.Body._viewListCount(inputs: inputs)
    }
}

extension _AnyForceModifiedView {
    fileprivate var _umodifiedHosted: _AnyUnmodifiedView<Self> {
        _AnyUnmodifiedView(base: self)
    }
}

public protocol _ThinForceModifiedView<ViewModifierType>: _AnyForceModifiedView, DynamicProperty, View {
    associatedtype ViewModifierType: Initiable
    
    static var _viewModifier: ViewModifierType { get }
}

public protocol _ForceModifiedView<ViewModifierType>: _AnyForceModifiedView, DynamicProperty, View {
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
        if Self._disableForceModifiedViewModification {
            return _AnyUnmodifiedView<Self>._makeView(view: view[\._umodifiedHosted], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        if Self._disableForceModifiedViewModification {
            return _AnyUnmodifiedView<Self>._makeViewList(view: view[\._umodifiedHosted], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        if Self._disableForceModifiedViewModification {
            return _AnyUnmodifiedView<Self>._viewListCount(inputs: inputs)
        }
        
        return _ThinModifiedBody._viewListCount(inputs: inputs)
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
        if Self._disableForceModifiedViewModification {
            return Body._makeView(view: view[\.body], inputs: inputs)
        }

        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinForceModifiedBody._makeView(view: _modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        if Self._disableForceModifiedViewModification {
            return Body._makeViewList(view: view[\.body], inputs: inputs)
        }

        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let _modifiedView = view[keyPath]
        
        return _ThinForceModifiedBody._makeViewList(view: _modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        if Self._disableForceModifiedViewModification {
            return Body._viewListCount(inputs: inputs)
        }

        return _ThinForceModifiedBody._viewListCount(inputs: inputs)
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
        modifier.body(
            root: content,
            content: LazyView { content.body }
        )
    }
}

package enum _ForceModifiedView_TaskLocalValues {
    @TaskLocal package static var root: (any View)?
}
