//
// Copyright (c) Vatsal Manot
//

import Combine
import Swallow
import SwiftUIX

fileprivate class _DynamicReplacementManager: ObservableObject {
    @MainActor(unsafe)
    static let shared = _DynamicReplacementManager()
    
    @MainActor
    @Published package(set) public var generation = 0
    @MainActor
    let publisher = PassthroughSubject<Void, Never>()
    @MainActor
    private var cancellable: AnyCancellable? = nil
    
    @MainActor
    init() {
        cancellable = NotificationCenter.default
            .publisher(
                for: Notification.Name("com.vmanot.Swallow._dynamicReplacement")
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let `self` = self else {
                    return
                }
                
                Task { @MainActor in
                    self.generation += 1
                    self.publisher.send()
                }
            }
    }
}

// MARK: - Conformances

extension _DynamicReplacementManager: Publisher {
    typealias Output = Void
    typealias Failure = Never
    
    func receive<S>(
        subscriber: S
    ) where S: Subscriber<Void, Never> {
        publisher.receive(subscriber: subscriber)
    }
}

// MARK: - Supplementary

extension View {
    public typealias _DynamicReplacementObserver = _View_DynamicReplacementObserver
    public typealias _ObserveDynamicReplacementManager = _View_ObserveDynamicReplacementManager
}

// MARK: - Auxiliary

@propertyWrapper
public struct _View_DynamicReplacementObserver: Initiable, _SwiftUIZ_DynamicProperty {
    @ObservedObject private var base = _DynamicReplacementManager.shared
    
    public var wrappedValue: Int {
        get {
            self.base.generation
        } set {
            _ = newValue
        }
    }
    
    public init() {
        
    }
}

public struct _View_ObserveDynamicReplacementManager: Initiable, SwiftUI.ViewModifier {
    @ObservedObject private var dynamicReplacementManager = _DynamicReplacementManager.shared
    
    @State private var toggle: Bool = false
    
    private let operation: () -> Void
    
    public init(operation: @escaping () -> Void) {
        self.operation = operation
    }
    
    public init() {
        self.init(operation: { })
    }
    
    public func body(content: Content) -> some View {
        let _ = $dynamicReplacementManager
        let _ = _dynamicReplacementManager
        
        content
            .environment(\._dynamicReplacementManager_generation, dynamicReplacementManager.generation)
            .background(ZeroSizeView().id(dynamicReplacementManager.generation))
            .animation(.default, value: dynamicReplacementManager.generation)
            .eraseToAnyView()
            ._onChange(of: dynamicReplacementManager.generation) { _ in
                operation()
            }
    }
}

extension EnvironmentValues {
    private struct _DynamicReplacementManager_Generation_EnvironmentKey: EnvironmentKey {
        static var defaultValue: Int {
            0
        }
    }
    
    fileprivate var _dynamicReplacementManager_generation: Int {
        get {
            self[_DynamicReplacementManager_Generation_EnvironmentKey.self]
        } set {
            self[_DynamicReplacementManager_Generation_EnvironmentKey.self] = newValue
        }
    }
}
