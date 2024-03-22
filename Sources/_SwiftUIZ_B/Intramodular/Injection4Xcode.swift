//
// Copyright (c) Vatsal Manot
//

import Combine
import Swallow
import SwiftUI

extension View {
    public typealias ObservedInjection4Xcode = Injection4Xcode._SwiftUI_PropertyWrapper
}

extension Injection4Xcode {
    @propertyWrapper
    public struct _SwiftUI_PropertyWrapper: DynamicProperty, PropertyWrapper {
        @ObservedObject private var base = Injection4Xcode.shared
        
        public var wrappedValue: Injection4Xcode {
            get {
                self.base
            } set {
                _ = newValue
            }
        }
        
        public init() {
            
        }
    }
}

public class Injection4Xcode: ObservableObject, Publisher {
    public typealias Output = Void
    public typealias Failure = Never
    
    @MainActor(unsafe)
    public static let shared = Injection4Xcode()
    
    @MainActor
    @Published package(set) public var increment = 0
    @MainActor
    package let publisher = PassthroughSubject<Void, Never>()
    @MainActor
    package var cancellable: AnyCancellable? = nil
    
    @usableFromInline
    @MainActor
    init() {
        cancellable = NotificationCenter.default
            .publisher(
                for: Notification.Name("INJECTION_BUNDLE_NOTIFICATION")
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let `self` = self else {
                    return
                }
                
                Task { @MainActor in
                    self.increment += 1
                    self.publisher.send()
                }
            }
    }
    
    public func receive<S>(
        subscriber: S
    ) where S: Subscriber<Void, Never> {
        publisher.receive(subscriber: subscriber)
    }
}

extension Injection4Xcode {
    @MainActor
    public struct ViewModifier: SwiftUI.ViewModifier {
        @ObservedObject private var _injection4Xcode = Injection4Xcode.shared
        
        @State var toggle: Bool = false
        
        @MainActor
        public func body(content: Content) -> some View {
            let _ = $_injection4Xcode
            let _ = _injection4Xcode
                        
            content
                .environment(\._injection4XcodeIncrement, _injection4Xcode.increment)
                .background(ZeroSizeView().id(_injection4Xcode.increment))
                .animation(.default, value: _injection4Xcode.increment)
                .eraseToAnyView()
        }
    }
}

extension EnvironmentValues {
    struct _Injection4XcodeIncrementKey: EnvironmentKey {
        static var defaultValue: Int {
            0
        }
    }
    
    var _injection4XcodeIncrement: Int {
        get {
            self[_Injection4XcodeIncrementKey.self]
        } set {
            self[_Injection4XcodeIncrementKey.self] = newValue
        }
    }
}
