//
// Copyright (c) Vatsal Manot
//

import Swallow

@_spi(Internal)
public class _SwiftUIZ_DynamicViewContentProvisioningContext {
    public struct ParameterKey: Hashable {
        let key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>
        let id: AnyHashable
    }
    
    public var parameterValues: [ParameterKey: Any] = [:]
    
    public var isEmpty: Bool {
        parameterValues.isEmpty
    }
    
    public init() {
        
    }
    
    public func hydrate(
        from values: _SwiftUIZ_DynamicViewParameterList,
        context: _SwiftUIZ_DynamicViewReceiverContext
    ) {
        for key in context.bridge.descriptor._SwiftUIZ_viewParameters {
            parameterValues[ParameterKey(key: key.key, id: key.id)] = values.storage[key.key]!
        }
    }
}

// MARK: - Auxiliary

@_spi(Internal)
extension EnvironmentValues {
    @EnvironmentValue public var _dynamicViewProvisioningContext = _SwiftUIZ_DynamicViewContentProvisioningContext()
}
