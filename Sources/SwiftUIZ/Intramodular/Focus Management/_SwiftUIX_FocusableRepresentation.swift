//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

public struct _SwiftUIX_FocusableRepresentation: Hashable, _HasPreferenceKey, Identifiable, MergeOperatable {
    public typealias _PreferenceKey = Collected._PreferenceKey
    
    public var id: _TypeHashingAnyHashable
    public var interactions: [_SwiftUIX_FocusInteractions: Action] = [:]
    
    public mutating func mergeInPlace(with other: Self) {
        interactions.merge(other.interactions, uniquingKeysWith: { lhs, rhs in
            rhs
        })
    }
    
    public func activate() throws {
        try interactions[.activate].unwrap().perform()
    }
}
extension _SwiftUIX_FocusableRepresentation {
    public struct Collected: Hashable, _HasPreferenceKey, Initiable {
        public typealias _PreferenceKey = _InitiableMergeOperatableTypeToPreferenceKeyAdaptor<Self>
        
        var representationsByNamespace: [Namespace.ID?: OrderedDictionary<_TypeHashingAnyHashable, _SwiftUIX_FocusableRepresentation>] = [:]
        
        public init() {
            
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
    }
}
extension _SwiftUIX_FocusableRepresentation.Collected: MergeOperatable {
    public mutating func mergeInPlace(with other: Self) {
        representationsByNamespace.merge(
            other.representationsByNamespace,
            uniquingKeysWith: { lhs, rhs in
                lhs.merging(rhs) { lhs, rhs in
                    lhs.mergingInPlace(with: rhs)
                }
            }
        )
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
                key: _SwiftUIX_FocusableRepresentation._PreferenceKey.self,
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
        transformPreference(_SwiftUIX_FocusableRepresentation._PreferenceKey.self) { value in
            value._assignTopLevelNamespace(namespace)
        }
    }
}
