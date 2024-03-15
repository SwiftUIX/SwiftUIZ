//
// Copyright (c) Vatsal Manot
//

import _DVGraph
import Runtime
import Swallow

public struct _SwiftUIZ_ViewParameterDescriptor {
    public let id: AnyHashable
    public let key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>
}

extension _SwiftUIZ_ViewParameterDescriptor {
    @RuntimeDiscoverable
    public struct _DVViewTypeDescriptorFiller: _DVViewTypeDescriptorFilling, Hashable {
        public static func update(
            _ descriptor: inout _DVViewTypeDescriptor,
            context: _DVDescriptorCreateContext
        ) throws {
            for field in context.view {
                if let value = field.value as? (any _ViewParameterType) {
                    guard let id = value.id else {
                        throw Never.Reason.unexpected
                    }
                    
                    descriptor._SwiftUIZ_viewParameters.append(
                        _SwiftUIZ_ViewParameterDescriptor(
                            id: id,
                            key: value.key
                        )
                    )
                }
            }
        }
    }
}

extension _DVViewTypeDescriptor {
    public var _SwiftUIZ_viewParameters: [_SwiftUIZ_ViewParameterDescriptor] {
        get {
            self[Array<_SwiftUIZ_ViewParameterDescriptor>.self]
        } set {
            self[Array<_SwiftUIZ_ViewParameterDescriptor>.self] = newValue
        }
    }
}
