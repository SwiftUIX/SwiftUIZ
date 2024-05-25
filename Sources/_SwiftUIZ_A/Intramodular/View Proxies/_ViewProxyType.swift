//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

/// A convenience protocol that allows building `<View>Proxy` style APIs quickly.
public protocol _ViewProxyType: Equatable {
    init(_nilLiteral: ())
}

extension _ViewProxyType where Self: AnyObject {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

public protocol _ViewProxyContainer {
    associatedtype WrappedValue: _ViewProxyType
    
    var wrappedValue: WrappedValue { get }
}

public struct _ViewProxyReader<Proxy: _ViewProxyType, Content: View>: View {
    @Environment(\.[_providedViewProxyOfType: _SwiftUIX_Metatype<Proxy.Type>(Proxy.self)]) private var parentProvidedProxy
    
    private let content: (Proxy) -> Content
    
    @State private var readProxy: Proxy?
    @State private var foo: Bool = false

    @ViewStorage private var initialPassComplete: Bool = false
    
    private var resolvedProxy: Proxy {
        guard let proxy = readProxy ?? parentProvidedProxy else {
            if initialPassComplete {
                runtimeIssue("Failed to resolve proxy: \(Proxy.self)")
            }
            
            return .init(_nilLiteral: ())
        }
        
        return proxy
    }
    
    public init(
        @ViewBuilder content: @escaping (Proxy) -> Content
    ) {
        self.content = content
    }
        
    public var body: some View {
        content(resolvedProxy)
            .background(ZeroSizeView().id(foo))
            .onPreferenceChange(_ProvideViewProxyPreferenceKey<Proxy>.self) { proxy in
                readProxy = proxy
                
                foo.toggle()
            }
            .task {
                DispatchQueue.main.async {
                    initialPassComplete = true
                }
            }
    }
}

extension View {
    public func _provideViewProxy<Proxy: _ViewProxyType>(
        _ proxy: Proxy
    ) -> some View {
        modifier(_ProvideViewProxy(proxy: proxy))
    }
    
    public func _provideViewProxy<Proxy: _ViewProxyType>(
        _ proxy: Proxy,
        resolve: (inout Proxy) -> Void
    ) -> some View {
        var resolvedProxy = proxy
        
        resolve(&resolvedProxy)
        
        return modifier(_ProvideViewProxy(proxy: resolvedProxy))
    }
}

fileprivate struct _ProvideViewProxy<Proxy: _ViewProxyType>: ViewModifier {
    let proxy: Proxy
    
    func body(content: Content) -> some View {
        content
            .preference(key: _ProvideViewProxyPreferenceKey<Proxy>.self, value: proxy)
            .environment(\.[_providedViewProxyOfType: _SwiftUIX_Metatype<Proxy.Type>(Proxy.self)], proxy)
    }
}

fileprivate struct _ProvideViewProxyPreferenceKey<Proxy: _ViewProxyType>: PreferenceKey {
    static var defaultValue: Proxy? {
        nil
    }
    
    static func reduce(value: inout Proxy?, nextValue: () -> Proxy?) {
        value = value ?? nextValue()
    }
}

extension EnvironmentValues {
    fileprivate struct _ProvidedViewProxyKey<Proxy: _ViewProxyType>: EnvironmentKey {
        static var defaultValue: Proxy? {
            nil
        }
    }
    
    fileprivate subscript<Proxy: _ViewProxyType>(
        _providedViewProxyOfType type: _SwiftUIX_Metatype<Proxy.Type>
    ) -> Proxy? {
        get {
            self[_ProvidedViewProxyKey<Proxy>.self]
        } set {
            self[_ProvidedViewProxyKey<Proxy>.self] = newValue
        }
    }
    
    public subscript<Proxy: _ViewProxyType>(
        _ type: Proxy.Type
    ) -> Proxy? {
        get {
            self[_providedViewProxyOfType: .init(type)]
        }
    }
}

// MARK: - Example Implementation

@_spi(Private)
public struct _ExampleViewProxy: Equatable {
    
}

@_spi(Private)
extension _ExampleViewProxy: _ViewProxyType {
    public init(_nilLiteral: ()) {
        
    }
}

@_spi(Private)
public struct _ExampleProxyReader<Content: View>: View {
    private let content: (_ExampleViewProxy) -> Content
    
    public init(
        @ViewBuilder content: @escaping (_ExampleViewProxy) -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        _ViewProxyReader(content: content)
    }
}
