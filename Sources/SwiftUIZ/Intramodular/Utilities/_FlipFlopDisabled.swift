//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import Merge
import SwiftUI

@propertyWrapper
public final class _FlipFlopDisabled<T: Equatable>: _CancellablesProviding {
    private var _lastToLastValue: T?
    private var _lastValue: T? {
        didSet {
            _lastToLastValue = oldValue
        }
    }
    private var _lastValueWriteDate = Date()
    private var _value: T {
        didSet {
            _lastValue = oldValue
        }
    }
    
    private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride
    
    public var wrappedValue: T {
        get {
            _value
        } set {
            let interval = try! debounceInterval.timeInterval.toTimeInterval()
            let now = Date()
            let expiry: Date = _lastValueWriteDate.addingTimeInterval(interval)
            
            assert((now.timeIntervalSince1970 > expiry.timeIntervalSince1970) == (now > expiry))
            
            if _isThisNewValueAFlip(newValue) {
                if now > expiry {
                    _value = newValue
                } else {
                    _ = newValue
                }
            } else {
                _value = newValue
            }
            
            _lastValueWriteDate = now
        }
    }
    
    func _isThisNewValueAFlip(_ newValue: T) -> Bool {
        guard let _lastToLastValue, let _lastValue else {
            return false
        }
        
        /// Can't be a flip if it's the same value.
        guard self._value != newValue else {
            return false
        }
        
        if _lastToLastValue == wrappedValue, _lastValue == newValue {
            return true
        } else if _lastValue == newValue {
            return true
        } else {
            return false
        }
    }
    
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance enclosingInstance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, _FlipFlopDisabled>
    ) -> T {
        get {
            enclosingInstance[keyPath: storageKeyPath].wrappedValue
        } set {
            _ObservableObject_objectWillChange_send(enclosingInstance)
            
            enclosingInstance[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
    
    public init(
        wrappedValue: T,
        within debounceInterval: DispatchQueue.SchedulerTimeType.Stride
    ) {
        self._value = wrappedValue
        self.debounceInterval = debounceInterval
    }
}
