//
// Copyright (c) Vatsal Manot
//

import Runtime
@_spi(Internal) import SwiftUIX

@_spi(Internal)
public protocol _DVAttributeTypeDescriptor {
    static func update(
        _ descriptor: inout _DVViewTypeDescriptor,
        context: _DVDescriptorCreateContext
    ) throws
}

@_spi(Internal)
public struct _DVViewParameterAttributeDescriptor: _DVAttributeTypeDescriptor, Hashable {
    public static func update(
        _ descriptor: inout _DVViewTypeDescriptor,
        context: _DVDescriptorCreateContext
    ) throws {
        for field in context.view {
            if let value = field.value as? (any _ViewParameterType) {
                guard let id = value.id else {
                    throw Never.Reason.unexpected
                }
                
                descriptor.parameters.append(
                    _DVViewTypeDescriptor.Parameter(
                        id: id,
                        key: value.key
                    )
                )
            }
        }
    }
}


public struct _DVDescriptorCreateContext {
    let view: AnyNominalOrTupleMirror<any View>
}

@_spi(Internal)
public struct _DVViewTypeDescriptor: Hashable {
    public struct Parameter: Hashable {
        public let id: AnyHashable
        public let key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>
    }
    
    public var parameters: [Parameter] = []
    
    init() {
        
    }
    
    public init(
        from view: some View
    ) throws {
        let view = try AnyNominalOrTupleMirror<any View>(reflecting: view)
        let context = _DVDescriptorCreateContext(view: view)
                
        self.init()
        
        let attributeDescriptors: [any _DVAttributeTypeDescriptor.Type] = try TypeMetadata._queryAll(
            .conformsTo((any _DVAttributeTypeDescriptor).self),
            .nonAppleFramework,
            .pureSwift
        )
        
        for descriptor in attributeDescriptors {
            try descriptor.update(&self, context: context)
        }
    }
}

extension _DVViewTypeDescriptor: CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self) {
            [
                "parameters": parameters
            ]
        }
    }
}
