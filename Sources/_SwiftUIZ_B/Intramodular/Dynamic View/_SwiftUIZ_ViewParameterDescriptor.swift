//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import Runtime
import Swallow

public struct _SwiftUIZ_ViewParameterDescriptor {
    public let id: AnyHashable
    public let key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>
}

extension _SwiftUIZ_ViewParameterDescriptor {
    @RuntimeDiscoverable
    package struct _ViewTypeDescriptorUpdater: ViewTypeDescriptorUpdater, Hashable {
        package static func update(
            _ descriptor: inout ViewTypeDescriptor,
            context: ViewDescriptorCreateContext
        ) throws {
            for field in context.view {
                if field.key == "_preternatural" {
                    continue
                }

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

extension ViewTypeDescriptor {
    public var _SwiftUIZ_viewParameters: [_SwiftUIZ_ViewParameterDescriptor] {
        get {
            self[Array<_SwiftUIZ_ViewParameterDescriptor>.self]
        } set {
            self[Array<_SwiftUIZ_ViewParameterDescriptor>.self] = newValue
        }
    }
}
