//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

extension _VariadicViewChildren {
    public struct SubviewTraitPair<Trait, ID: Hashable>: Identifiable, View {
        public let base: Subview
        public let namespace: Namespace.ID?
        public let trait: Trait
        public let id: ID
        public let focusRepresentation: _FocusableViewProxy?
        
        private let propagateFocusRepresentation: (_FocusableViewProxy?) -> Void
        
        init(
            base: Subview,
            namespace: Namespace.ID?,
            trait: Trait,
            id: ID,
            focusRepresentation: _FocusableViewProxy?,
            propagateFocusRepresentation: @escaping (_FocusableViewProxy?) -> Void
        ) {
            self.base = base
            self.trait = trait
            self.namespace = namespace
            self.id = id
            self.focusRepresentation = focusRepresentation
            self.propagateFocusRepresentation = propagateFocusRepresentation
        }
        
        public var body: some View {
            _FocusableViewReader(adopting: namespace) { (focusProxy: _FocusableViewProxy) in
                base
                    ._onAppearAndChange(of: focusProxy) { focusProxy in
                        propagateFocusRepresentation(focusProxy)
                    }
                    .onDisappear {
                        propagateFocusRepresentation(nil)
                    }
            }
        }
    }
}

extension _VariadicViewChildren.SubviewTraitPair: Equatable where Trait: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.trait == rhs.trait && lhs.focusRepresentation == rhs.focusRepresentation
    }
}

extension _VariadicViewChildren.SubviewTraitPair: Hashable where Trait: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(trait)
        hasher.combine(focusRepresentation)
    }
}
