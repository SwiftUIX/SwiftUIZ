//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

public struct _DVModifiedConcreteAttribute<Node: _DVConcreteAttribute, Modifier: _DVConcreteAttributeModifier>: _DVConcreteAttribute where Node.AttributeEvaluator.Value == Modifier.SourceValue {
    public struct PositionHint: Hashable {
        private let base: Node.PositionHint
        private let modifierKey: Modifier.ModifierKey

        fileprivate init(
            base: Node.PositionHint,
            modifierKey: Modifier.ModifierKey
        ) {
            self.base = base
            self.modifierKey = modifierKey
        }
    }

    private let attribute: Node
    private let modifier: Modifier

    internal init(attribute: Node, modifier: Modifier) {
        self.attribute = attribute
        self.modifier = modifier
    }

    public var positionHint: PositionHint {
        PositionHint(
            base: attribute.positionHint,
            modifierKey: modifier.key
        )
    }

    public var _attributeEvaluator: ModifiedConcreteAttributeEvaluator<Node, Modifier> {
        AttributeEvaluator(attribute: attribute, modifier: modifier)
    }
}
