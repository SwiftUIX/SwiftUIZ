//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _FormSubmitModelAction {
    public private(set)  var type: Any.Type
    public private(set) var action: (Any) -> Void
    
    init(type: Any.Type, action: @escaping (Any) -> Void) {
        self.type = type
        self.action = action
    }
    
    public init() {
        self.type = Any.self
        self.action = { _ in
            runtimeIssue("No submit action registered for this view.")
        }
    }
    
    public init<T>(
        _ action: @escaping (T) -> Void
    ) {
        let type = T.self
        
        self.type = type
        self.action = { value in
            guard let value = value as? T else {
                assertionFailure("Expected an input of type \(type) but received \(Swift.type(of: value))")
                
                return
            }
            
            action(value)
        }
    }
    
    public func callAsFunction<T>(_ x: T) {
        action(x)
    }
}

extension _FormSubmitModelAction {
    public func disabled(
        _ disabled: Bool
    ) -> Self {
        var result = self
        
        let oldAction = self.action
        
        result.action = {
            guard !disabled else {
                return
            }
            
            oldAction($0)
        }
        
        return result
    }
}

extension EnvironmentValues {
    struct _FormSubmitModelActionKey: EnvironmentKey {
        static let defaultValue = _FormSubmitModelAction()
    }
    
    public var _submit: _FormSubmitModelAction {
        get {
            self[_FormSubmitModelActionKey.self]
        } set {
            self[_FormSubmitModelActionKey.self] = newValue
        }
    }
}

extension View {
    public func onSubmit<Model>(
        of model: Model.Type,
        perform action: @escaping (Model) -> Void
    ) -> some View {
        environment(\._submit, _FormSubmitModelAction(action))
    }
    
    public func submitDisabled(
        _ disabled: Bool
    ) -> some View {
        transformEnvironment(\._submit) {
            $0 = $0.disabled(disabled)
        }
    }
}
