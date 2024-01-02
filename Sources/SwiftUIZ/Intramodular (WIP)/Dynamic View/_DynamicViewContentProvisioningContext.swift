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
    
    public var parameterValues: [ParameterKey: Any] = [:]
    
    public var isEmpty: Bool {
        parameterValues.isEmpty
    }
    
    public init() {
        
    }
    
    public func hydrate(
        from values: _SwiftUIX_ViewParameters,
        context: _DynamicViewReceptor
    ) {
        for key in context.bridge.descriptor.parameters {
            parameterValues[ParameterKey(key: key.key, id: key.id)] = values.storage[key.key]!
        }
    }
}

// MARK: - Auxiliary

@_spi(Internal)
extension EnvironmentValues {
    @EnvironmentValue public var _dynamicViewProvisioningContext = _DynamicViewContentProvisioningContext()
}
