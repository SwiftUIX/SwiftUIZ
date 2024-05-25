//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _ViewGraphNodeResolvableContext<ResolvableType> {
    associatedtype ResolvableType: _ViewGraphNodeResolvable
}

public protocol _ViewGraphNodeResolvable {
    associatedtype ResolutionType = Self
    
    typealias Context = any _ViewGraphNodeResolvableContext<Self>
    
    func resolve(
        from node: any _DynamicViewGraphNodeType,
        context: Context
    ) throws -> ResolutionType
}

extension _ViewGraphNodeResolvable where ResolutionType == Self {
    public func resolve(
        from node: any _DynamicViewGraphNodeType,
        context: Context
    ) throws -> ResolutionType {
        return self
    }
}

extension _DynamicViewGraphNodeType {
    public func resolveAttribute<T>(
        _ shape: _ViewAttributeShape,
        as type: T.Type
    ) throws -> T {
        throw Never.Reason.unimplemented
    }
}

extension _DynamicViewGraphNodeType {
    public func resolve<T: _ViewGraphNodeResolvable>(
        _ x: T
    ) throws -> T.ResolutionType {
        let context = _ConcreteViewGraphNodeResolvableResolutionContext<T>()
        
        let result = try x.resolve(from: self, context: context)
        
        return result
    }
}

struct _ConcreteViewGraphNodeResolvableResolutionContext<T: _ViewGraphNodeResolvable>: _ViewGraphNodeResolvableContext {
    typealias ResolvableType = T
}

extension _DynamicViewGraphNodeType {
    public func hasParent<T: _ViewGraphNodeResolvable>(_ x: T) throws -> Bool {
        fatalError()
    }
}
