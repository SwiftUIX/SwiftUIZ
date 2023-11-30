//
// Copyright (c) Vatsal Manot
//

import Runtime
@_spi(Internal) import SwiftUIX

@_spi(Internal)
public struct _SwiftUIZ_ViewDescriptor: Hashable {
    public struct Parameter: Hashable {
        public let id: AnyHashable
        public let key: PartialKeyPath<_SwiftUIX_ViewParameterKeys>
    }
    
    public var parameters: [Parameter]
    
    public init(
        from view: some View
    ) throws {
        let mirror = try! AnyNominalOrTupleMirror(reflecting: view)
        
        self.parameters = []
        
        for field in mirror {
            if let value = field.value as? (any _ViewParameterType) {
                guard let id = value.id else {
                    throw Never.Reason.unexpected
                }
                
                parameters.append(.init(id: id, key: value.key))
            }
        }
    }
}
