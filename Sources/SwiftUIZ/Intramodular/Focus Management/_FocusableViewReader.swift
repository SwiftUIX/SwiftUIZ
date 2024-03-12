//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _FocusableViewReaderConfiguration: Hashable {
    var assignedTopLevelNamespace: Namespace.ID?
    
    init() {
        
    }
}

public struct _FocusableViewProxy: Hashable, Sequence {
    var configuration: _FocusableViewReaderConfiguration?
    
    fileprivate var rawValue: _SwiftUIX_FocusableRepresentation.Collected
    
    init() {
        self.configuration = nil
        self.rawValue = .init()
    }
    
    init(
        configuration: _FocusableViewReaderConfiguration,
        rawValue: _SwiftUIX_FocusableRepresentation.Collected
    ) {
        self.configuration = configuration
        self.rawValue = rawValue
    }
    
    public subscript<ID: Hashable>(_ id: ID) -> _SwiftUIX_FocusableRepresentation? {
        rawValue[id, namespace: configuration!.assignedTopLevelNamespace]
    }
    
    public func makeIterator() -> _SwiftUIX_FocusableRepresentation.Collected.Iterator {
        rawValue.makeIterator()
    }
    
    public func activate() throws {
        try first.unwrap().activate()
    }
}

public struct _FocusableViewReader<Content: View>: View {
    private let content: (_FocusableViewProxy) -> Content
    private var configuration = _FocusableViewReaderConfiguration()

    @State private var readProxy = _FocusableViewProxy()
    
    private var resolvedProxy: _FocusableViewProxy {
        var result = readProxy
        
        result.configuration = configuration
        
        return result
    }
    
    public init(
        adopting namespace: Namespace.ID?,
        @ViewBuilder content: @escaping (_FocusableViewProxy) -> Content
    ) {
        self.content = content
        self.configuration.assignedTopLevelNamespace = namespace
    }

    public var body: some View {
        content(resolvedProxy)
            ._assignTopLevelFocusableRepresentationNamespace(configuration.assignedTopLevelNamespace)
            .onPreferenceChange(_SwiftUIX_FocusableRepresentation._PreferenceKey.self) {
                readProxy.rawValue = $0
            }
    }
}
