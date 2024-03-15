//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _DVGraphEnvironmentContext {
    public var inheritance: [_DVGraph.Node.ID] = []
    public var attributeGraphScope = _DVConcreteAttributeGraph.Scope()
    public var attributeGraphOverrides = [_DVConcreteAttributeGraph.Override: any _DVOverrideOfConcreteAttribute]()
    public var attributeGraphObservers = [_DVConcreteAttributeGraphContext.Observer]()
    
    public init() {
        
    }
}

extension _DVGraphEnvironmentContext: MergeOperatable {
    public mutating func mergeInPlace(
        with other: _DVGraphEnvironmentContext
    ) {
        self.attributeGraphOverrides._unsafelyMerge(other.attributeGraphOverrides)
        self.attributeGraphObservers.append(contentsOf: other.attributeGraphObservers)
    }
}

extension _DVGraphEnvironmentContext {
    struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static let defaultValue = _DVGraphEnvironmentContext()
    }
}

extension EnvironmentValues {
    @MainActor
    public var _dynamicViewGraphContext: _DVGraphEnvironmentContext {
        get {
            self[_DVGraphEnvironmentContext.EnvironmentKey.self]
        } set {
            self[_DVGraphEnvironmentContext.EnvironmentKey.self] = newValue
        }
    }
    
    @MainActor
    public var _dynamicViewAttributeGraphContext: _DVConcreteAttributeGraphContext {
        get {
            _DVConcreteAttributeGraphContext(from: self)
        }
    }
}
