//
// Copyright (c) Vatsal Manot
//

import Combine
import Foundation
import Swift

public class _NSKeyValueObservedKeyPath<T: NSObject, Value, Member: Equatable>: ObservableObject {
    public weak var target: T? {
        didSet {
            guard target != oldValue else {
                return
            }
            
            setUpObservation()
        }
    }
    
    private let keyPath: KeyPath<T, Value>
    private let memberKeyPath: KeyPath<Value, Member>
    private let onChange: (Member) -> Void
    
    @Published public private(set) var value: Member?
    
    private var observation: NSKeyValueObservation?
    
    public init(
        target: T? = nil,
        keyPath: KeyPath<T, Value>,
        member memberKeyPath: KeyPath<Value, Member>,
        onChange: @escaping (Member) -> Void = { _ in }
    ) {
        self.target = target
        self.keyPath = keyPath
        self.memberKeyPath = memberKeyPath
        self.onChange = onChange
        self.value = target?[keyPath: keyPath][keyPath: memberKeyPath]
        
        setUpObservation()
    }
    
    public convenience init(
        target: T? = nil,
        keyPath: KeyPath<T, Value>,
        onChange: @escaping (Member) -> Void = { _ in }
    ) where Value == Member {
        self.init(
            target: target,
            keyPath: keyPath,
            member: \.self,
            onChange: onChange
        )
    }
    
    private func setUpObservation() {
        observation?.invalidate()
        observation = nil
        observation = target?.observe(keyPath, options: [.old, .new]) { [weak self] (value, change) in
            guard let `self` = self, let rootValue = change.newValue ?? change.oldValue else {
                assertionFailure()
                
                return
            }
            
            let value = rootValue[keyPath: self.memberKeyPath]
            
            if let oldValue = self.value {
                guard value != oldValue else {
                    return
                }
            }
            
            self.value = value
            self.onChange(value)
        }
    }
    
    deinit {
        observation?.invalidate()
    }
}
