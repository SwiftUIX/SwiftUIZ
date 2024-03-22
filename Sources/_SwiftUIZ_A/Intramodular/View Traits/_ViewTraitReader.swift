//
// Copyright (c) Vatsal Manot
//

import Swallow
import OrderedCollections
import SwiftUIX

public struct _ViewTraitReader<Source: View, Trait: SwiftUI._ViewTraitKey, TraitValue, ID: Hashable, Content: View>: View where Trait.Value == Optional<TraitValue> {
    public typealias Payload = OrderedDictionary<ID, _VariadicViewChildren.SubviewTraitPair<TraitValue, ID>>
    
    private let source: Source
    private let trait: KeyPath<_ViewTraitKeys, Trait.Type>
    private let id: (_VariadicViewChildren.Element, TraitValue) -> ID
    private let equatable: (TraitValue) -> AnyHashable
    private let content: (_VariadicViewChildren.Element, TraitValue) -> Content
    private let onChange: (Payload) -> Void
    
    @State private var payload: Payload?
    @State private var focusRepresentations: [ID: _FocusableViewProxy] = [:]
    
    @Namespace private var namespace
    
    private init(
        _ source: Source,
        trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: @escaping (_VariadicViewChildren.Element, TraitValue) -> ID,
        equatable: @escaping (TraitValue) -> AnyHashable,
        @ViewBuilder content: @escaping (_VariadicViewChildren.Element, TraitValue) -> Content,
        onChange: @escaping (Payload) -> Void
    ) {
        self.source = source
        self.trait = trait
        self.id = id
        self.equatable = equatable
        self.content = content
        self.onChange = onChange
    }
    
    public var body: some View {
        _VariadicViewAdapter(source) { (content: _SwiftUI_VariadicView<Source>) in
            let payload: Payload = content.children
                ._compactMap(\.1, { ($0, $0[trait: trait]) })
                ._orderedMapToUniqueKeysWithValues({
                    let key = self.id($0.0, $0.1)
                    let subview = _VariadicViewChildren.SubviewTraitPair(
                        base: $0.0,
                        namespace: namespace,
                        trait: $0.1,
                        id: key,
                        focusRepresentation: self.focusRepresentations[key],
                        propagateFocusRepresentation: { focusProxy in
                            if let focusProxy {
                                self.focusRepresentations[key] = focusProxy
                            } else {
                                self.focusRepresentations[key] = nil
                            }
                        }
                    )
                    
                    return (key: key, value: subview)
                })
            
            let data: [_ArbitrarilyIdentifiedValue<(_VariadicViewChildren.Element, TraitValue), ID>] = content.children
                ._compactMap(\.1, { element -> (_VariadicViewChildren.Element, TraitValue?) in
                    (element, element[trait: trait])
                })
                .map({ _ArbitrarilyIdentifiedValue(value: $0, id: { self.id($0.0, $0.1) }) })
            
            ZStack {
                ZeroSizeView()
                    .onAppear {
                        if self.payload == nil {
                            _payloadDidChange(payload)
                        }
                    }
                    .onChange(
                        of: payload.mapValues({ EqualityMapAdaptor(base: $0, transform: { Hashable2ple((self.equatable($0.trait), $0.focusRepresentation)) }) })
                    ) { payload in
                        _payloadDidChange(payload.mapValues({ $0.base }))
                    }
                
                ForEach(data) { element in
                    self.content(element.value.0, element.value.1)
                }
            }
        }
    }
    
    private func _payloadDidChange(
        _ payload: Payload
    ) {
        self.payload = payload
        
        onChange(payload)
    }
}

// MARK: - Initializers

extension _ViewTraitReader {
    public init(
        _ source: Source,
        trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        @ViewBuilder content: @escaping (_VariadicViewChildren.Element, TraitValue) -> Content
    ) {
        self.init(
            source,
            trait: trait,
            id: { _, trait in trait[keyPath: id] },
            equatable: { $0[keyPath: id] },
            content: content,
            onChange: { _ in }
        )
    }
    
    public init(
        _ source: Source,
        trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        @ViewBuilder content: @escaping (_VariadicViewChildren.Element, TraitValue) -> Content
    ) where TraitValue: Hashable {
        self.init(
            source,
            trait: trait,
            id: { _, trait in trait[keyPath: id] },
            equatable: { $0 },
            content: content,
            onChange: { _ in }
        )
    }
    
    fileprivate init(
        _ source: Source,
        trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        onChange: @escaping (Payload) -> Void
    ) where Content == EmptyView {
        self.init(
            source,
            trait: trait,
            id: { _, trait in trait[keyPath: id] },
            equatable: { $0[keyPath: id] },
            content: { _, _ in EmptyView() },
            onChange: onChange
        )
    }
    
    fileprivate init(
        _ source: Source,
        trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        onChange: @escaping (Payload) -> Void
    ) where TraitValue: Hashable, Content == EmptyView {
        self.init(
            source,
            trait: trait,
            id: { _, trait in trait[keyPath: id] },
            equatable: { $0 },
            content: { _, _ in EmptyView() },
            onChange: onChange
        )
    }
}

// MARK: - Initializers

extension View {
    public func _onChange<Trait: SwiftUI._ViewTraitKey, TraitValue, ID: Hashable, Source: View>(
        of trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        from source: Source,
        perform fn: @escaping (OrderedDictionary<ID, _VariadicViewChildren.SubviewTraitPair<TraitValue, ID>>) -> Void
    ) -> some View where Trait.Value == Optional<TraitValue> {
        background {
            _ViewTraitReader(source, trait: trait, id: id, onChange: fn)
        }
    }
    
    public func _onChange<Trait: SwiftUI._ViewTraitKey, TraitValue: Hashable, ID: Hashable, Source: View>(
        of trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        id: KeyPath<TraitValue, ID>,
        from source: Source,
        perform fn: @escaping (OrderedDictionary<ID, _VariadicViewChildren.SubviewTraitPair<TraitValue, ID>>) -> Void
    ) -> some View where Trait.Value == Optional<TraitValue> {
        background {
            _ViewTraitReader(source, trait: trait, id: id, onChange: fn)
        }
    }
    
    public func _onChange<Trait: SwiftUI._ViewTraitKey, TraitValue: Identifiable, Source: View>(
        of trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        from source: Source,
        perform fn: @escaping (OrderedDictionary<TraitValue.ID, _VariadicViewChildren.SubviewTraitPair<TraitValue, TraitValue.ID>>) -> Void
    ) -> some View where Trait.Value == Optional<TraitValue> {
        background {
            _ViewTraitReader(source, trait: trait, id: \.id, onChange: fn)
        }
    }
    
    public func _onChange<Trait: SwiftUI._ViewTraitKey, TraitValue: Hashable & Identifiable, Source: View>(
        of trait: KeyPath<_ViewTraitKeys, Trait.Type>,
        from source: Source,
        perform fn: @escaping (OrderedDictionary<TraitValue.ID, _VariadicViewChildren.SubviewTraitPair<TraitValue, TraitValue.ID>>) -> Void
    ) -> some View where Trait.Value == Optional<TraitValue> {
        background {
            _ViewTraitReader(source, trait: trait, id: \.id, onChange: fn)
        }
    }
}

// MARK: - Auxiliary

fileprivate struct EqualityMapAdaptor<Base, Transformed: Equatable>: Equatable {
    let base: Base
    let transform: (Base) -> Transformed
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.transform(lhs.base) == rhs.transform(rhs.base)
    }
}
