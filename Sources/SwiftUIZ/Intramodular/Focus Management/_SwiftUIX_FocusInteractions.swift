//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

public struct _SwiftUIX_FocusInteractions: Hashable, OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let activate = Self(rawValue: 1 << 0)
    public static let edit = Self(rawValue: 1 << 1)
}

public struct _SwiftUIX_FocusableRepresentation: Hashable, Identifiable {
    public var id: _TypeHashingAnyHashable
    public var interactions: [_SwiftUIX_FocusInteractions: Action] = [:]
    
    func merge(with other: Self) -> Self {
        var result = self
        
        result.interactions.merge(other.interactions, uniquingKeysWith: { lhs, rhs in
            rhs
        })
        
        return result
    }
    
    public func activate() throws {
        try interactions[.activate].unwrap().perform()
    }
}

extension _SwiftUIX_FocusableRepresentation {
    public struct PreferenceKey: SwiftUI.PreferenceKey {
        public typealias Value = Collected
        
        public static let defaultValue: Value = .init()
        
        public static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = value.merge(with: nextValue())
        }
    }
}

extension _SwiftUIX_FocusableRepresentation {
    public struct Collected: Hashable {
        var representationsByNamespace: [Namespace.ID?: OrderedDictionary<_TypeHashingAnyHashable, _SwiftUIX_FocusableRepresentation>] = [:]
        
        init() {
            
        }
        
        init(
            _ representation: _SwiftUIX_FocusableRepresentation,
            namespace: Namespace.ID? = nil
        ) {
            self.representationsByNamespace[namespace, default: .init()][representation.id] = representation
        }
        
        subscript<ID: Hashable>(
            id: ID,
            namespace namespaceID: Namespace.ID? = nil
        ) -> _SwiftUIX_FocusableRepresentation? {
            get {
                representationsByNamespace[namespaceID]?[id._eraseToTypeHashingAnyHashable()]
            }
        }
        
        mutating func _assignTopLevelNamespace(
            _ namespace: Namespace.ID?
        ) {
            guard let namespace else {
                return
            }
            
            guard !representationsByNamespace.isEmpty else {
                return
            }
            
            let topLevel = representationsByNamespace.removeValue(forKey: Optional<Namespace.ID>.none)
            
            representationsByNamespace[namespace] = topLevel
        }
        
        func merge(with other: Self) -> Self {
            var result = self
            
            result.representationsByNamespace.merge(
                result.representationsByNamespace,
                uniquingKeysWith: { lhs, rhs in
                    lhs.merging(rhs) { lhs, rhs in
                        lhs.merge(with: rhs)
                    }
                }
            )
            
            return result
        }
    }
}

extension _SwiftUIX_FocusableRepresentation.Collected: Sequence {
    public func makeIterator() -> AnyIterator<_SwiftUIX_FocusableRepresentation> {
        representationsByNamespace.flatMap {
            $0.value.values
        }
        .makeIterator()
        .eraseToAnyIterator()
    }
}

struct _DonateFocusableRepresentation: ViewModifier {
    private let namespace: Namespace.ID?
    private let interactions: [_SwiftUIX_FocusInteractions: Action]
    
    @State private var id: _TypeHashingAnyHashable = _TypeHashingAnyHashable(UUID())
    
    init(
        namespace: Namespace.ID?,
        interactions: [_SwiftUIX_FocusInteractions: Action]
    ) {
        self.namespace = namespace
        self.interactions = interactions
    }
    
    func body(content: Content) -> some View {
        _CreateActionTrampolines(actions: interactions) { interactions in
            content.preference(
                key: _SwiftUIX_FocusableRepresentation.PreferenceKey.self,
                value: .init(.init(id: id, interactions: interactions))
            )
        }
    }
}

extension View {
    public func _donateFocusableRepresentation(
        namespace: Namespace.ID?,
        interactions: [_SwiftUIX_FocusInteractions: Action]
    ) -> some View {
        modifier(_DonateFocusableRepresentation(namespace: namespace, interactions: interactions))
    }
    
    public func _assignTopLevelFocusableRepresentationNamespace(
        _ namespace: Namespace.ID?
    ) -> some View {
        transformPreference(_SwiftUIX_FocusableRepresentation.PreferenceKey.self) { value in
            value._assignTopLevelNamespace(namespace)
        }
    }
}
