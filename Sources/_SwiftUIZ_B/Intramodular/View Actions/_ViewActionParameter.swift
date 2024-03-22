//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public typealias _ViewActionParameterID = UUID

protocol _ViewActionParameterType: Identifiable, MutablePropertyWrapper {
    var id: _ViewActionParameterID { get }
}

@propertyWrapper
public struct _ViewActionParameter<T> {
    public var id = _ViewActionParameterID()
    
    public var _wrappedValue: T?
    
    public var wrappedValue: T {
        get {
            _TaskLocalValues.identifyViewActionParameter(id)
            
            fatalError()
        } set {
            _TaskLocalValues.identifyViewActionParameter(id)
            
            _wrappedValue = newValue
        }
    }
    
    public init() {
        
    }
}

extension _TaskLocalValues {
    @TaskLocal static var identifyViewActionParameter: (_ViewActionParameterID) -> Void = { _ in }
}
