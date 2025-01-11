//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow
import SwallowMacrosClient
import _SwiftUIZ_A

public struct _ShallowEnvironmentKeyDescriptor {
    public let id: AnyHashable
    public let key: PartialKeyPath<_ShallowEnvironmentValues.Keys>
}

extension _ShallowEnvironmentKeyDescriptor {
    @RuntimeDiscoverable
    package struct _ViewTypeDescriptorStaticUpdater: _StaticViewTypeDescriptor.StaticUpdater, Hashable {
        package static func update(
            _ descriptor: inout _StaticViewTypeDescriptor,
            context: _StaticViewTypeDescriptor.UpdateContext
        ) throws {
            for field in context.view {
                if field.key.stringValue.hasSuffix("_dynamicReplacementObserver") {
                    continue
                }

                if let value = field.value as? (any _ShallowEnvironmentType) {
                    guard let id = value.id else {
                        throw Never.Reason.unexpected
                    }
                    
                    descriptor._shallowEnvironmentKeys.append(
                        .init(
                            id: id,
                            key: value.key
                        )
                    )
                }
            }
        }
    }
}

extension _StaticViewTypeDescriptor {
    public var _shallowEnvironmentKeys: [_ShallowEnvironmentKeyDescriptor] {
        get {
            self[Array.self]
        } set {
            self[Array.self] = newValue
        }
    }
}
