//
// Copyright (c) Vatsal Manot
//

import Swallow

@_spi(Internal)
public class _DynamicViewContentProvisioningContext {
    public struct ParameterKey: Hashable {
        let key: PartialKeyPath<_SwiftUIX_ViewParameterKeys>
        let id: AnyHashable
    }
    
    public var viewParameterValues: [ParameterKey: Any] = [:]
    
    public var isEmpty: Bool {
        viewParameterValues.isEmpty
    }
    
    public init() {
        
    }
    
    public func hydrate(
        from values: _SwiftUIX_ViewParameters,
        context: _DynamicViewReceptor
    ) {
        for key in context.bridge.descriptor.parameters {
            viewParameterValues[ParameterKey(key: key.key, id: key.id)] = values.storage[key.key]!
        }
    }
}

@_spi(Internal)
extension EnvironmentValues {
    @EnvironmentValue public var _dynamicViewProvisioningContext = _DynamicViewContentProvisioningContext()
}
