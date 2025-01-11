//
// Copyright (c) Vatsal Manot
//

import SwiftUI

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

extension _AnyForceModifiedView {
    var _umodifiedHosted: _AnyUnmodifiedView<Self> {
        _AnyUnmodifiedView(base: self)
    }
}

struct _AnyUnmodifiedView<Base: DynamicProperty & View>: View {
    var base: Base
    
    var body: some View {
        base.body
    }
    
    static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> SwiftUI._ViewOutputs {
        let body: _GraphValue<Base.Body> = view[\Self.base.body]
        
        return Base.Body._makeView(view: body, inputs: inputs)
    }
    
    static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> SwiftUI._ViewListOutputs {
        let body: _GraphValue<Base.Body> = view[\Self.base.body]
        
        return Base.Body._makeViewList(view: body, inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    static func _viewListCount(
        inputs: SwiftUI._ViewListCountInputs
    ) -> Int? {
        Base.Body._viewListCount(inputs: inputs)
    }
}
