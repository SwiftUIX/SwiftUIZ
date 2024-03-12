//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A view trait expressed as a view.
public protocol _ViewTraitsRepresentingView: View where Body == _ViewTraitsRepresentingView_Body {
    var body: _ViewTraitsRepresentingView_Body { get }
    
    func write<TraitValues: _ViewTraitValuesProtocol>(to _: inout TraitValues)
}

// MARK: - Implementation

extension _ViewTraitsRepresentingView {
    public var body: _ViewTraitsRepresentingView_Body {
        _ViewTraitsRepresentingView_Body {
            var values = _ViewTraitsRepresentingView_Builder()
            
            self.write(to: &values)
            
            return values.view
                .eraseToAnyView()
                .accessibilityHidden(true)
        }
    }
}

// MARK: - Internal

private struct _ViewTraitsRepresentingView_Builder: _ViewTraitValuesProtocol {
    var view: any View = ZeroSizeView()
    
    subscript<Key: _ViewTraitKey>(
        _ key: Key.Type
    ) -> Key.Value {
        get {
            assertionFailure()
            
            return Key.defaultValue
        } set {
            view = view._trait(key, newValue)
        }
    }
}

public struct _ViewTraitsRepresentingView_Body: View {
    let content: AnyView
    
    public var body: some View {
        content
    }

    fileprivate init<Content: View>(content: () -> Content) {
        self.content = content().eraseToAnyView()
    }
}
