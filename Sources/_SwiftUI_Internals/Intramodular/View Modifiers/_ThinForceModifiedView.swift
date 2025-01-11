//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Swallow

public protocol _ThinForceModifiedView<ViewModifierType>: _AnyForceModifiedView, DynamicProperty, View {
    associatedtype ViewModifierType: Initiable
    
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
    ) -> SwiftUI._ViewOutputs {
        if Self._disableForceModifiedViewModification {
            return _AnyUnmodifiedView<Self>._makeView(view: view[\._umodifiedHosted], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeView(view: modifiedView, inputs: inputs)
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> SwiftUI._ViewListOutputs {
        if Self._disableForceModifiedViewModification {
            return _AnyUnmodifiedView<Self>._makeViewList(view: view[\._umodifiedHosted], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        return _ThinModifiedBody._makeViewList(view: modifiedView, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: SwiftUI._ViewListCountInputs
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
    ) -> SwiftUI._ViewOutputs {
        if Self._disableForceModifiedViewModification {
            return Body._makeView(view: view[\.body], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        let result: _ViewOutputs = _ThinForceModifiedBody._makeView(view: modifiedView, inputs: inputs)
        
        return result
    }
    
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> SwiftUI._ViewListOutputs {
        if Self._disableForceModifiedViewModification {
            return Body._makeViewList(view: view[\.body], inputs: inputs)
        }
        
        let keyPath: KeyPath<Self, _ThinForceModifiedBody> = \Self.[_lazilyModifiedBy: Metatype(ViewModifierType.self)]
        
        let modifiedView = view[keyPath]
        
        let result: _ViewListOutputs = _ThinForceModifiedBody._makeViewList(view: modifiedView, inputs: inputs)
        
        return result
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: SwiftUI._ViewListCountInputs
    ) -> Int? {
        if Self._disableForceModifiedViewModification {
            return Body._viewListCount(inputs: inputs)
        }
        
        return _ThinForceModifiedBody._viewListCount(inputs: inputs)
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
