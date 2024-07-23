//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import EngineCore

/// A key that defines a list of `View`'s that are defined by descendants.
///
/// A ``ViewOutputKey`` can be optimized to be static rather than
/// type-erasure with `AnyView` by defining the `Content`.
///
/// Use the ``View/viewOutput(_:source:)`` on a descendant to
/// add the view to the output.
///
/// A ``ViewOutputKey`` value can be read by a ``ViewOutputKeyReader``.
/// 
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol ViewOutputKey {
    associatedtype Content: View = AnyView
    typealias Value = ViewOutputList<Content>
    static func reduce(value: inout Value, nextValue: () -> Value)
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewOutputKey where Value == ViewOutputList<Content> {
    public static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value.mergeInPlace(with: nextValue())
    }
}

/// A list of views sourced by a ``ViewOutputKey``
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ViewOutputList<Content: View>: View, RandomAccessCollection {
    @frozen
    public struct Subview: View, Identifiable {
        public struct ID: Hashable {
            var value: Namespace.ID
        }

        public var id: ID
        public var explicitID: AnyHashable?
        public var content: Content

        var phase: UpdatePhase.Value

        init(
            id: Namespace.ID,
            explicitID: AnyHashable?,
            phase: UpdatePhase.Value,
            content: Content
        ) {
            self.id = ID(value: id)
            self.explicitID = explicitID
            self.phase = phase
            self.content = content
        }

        public var body: some View {
            content
        }
    }

    public private(set) var elements: [Subview]
    public private(set) var elementsByExplicitID: [AnyHashable: Subview]

    public init(elements: [Subview]) {
        self.elements = elements
        self.elementsByExplicitID = Dictionary(uniqueKeysWithValues: elements.compactMap {
            if let id = $0.explicitID {
                return (id, $0)
            } else {
                return nil
            }
        })
    }
    
    public mutating func mergeInPlace(with other: Self) {
        self.elements.append(contentsOf: other.elements)
        self.elementsByExplicitID.merge(other.elementsByExplicitID, uniquingKeysWith: { lhs, rhs in rhs })
    }

    public var body: some View {
        ForEach(elements, id: \.id) { child in
            child
        }
    }

    // MARK: Collection

    public typealias Element = Subview
    public typealias Iterator = IndexingIterator<Array<Element>>
    public typealias Index = Int

    public func makeIterator() -> Iterator {
        elements.makeIterator()
    }

    public var startIndex: Index {
        elements.startIndex
    }

    public var endIndex: Index {
        elements.endIndex
    }

    public subscript(position: Index) -> Element {
        elements[position]
    }

    public func index(after index: Index) -> Index {
        elements.index(after: index)
    }
}

/// A modifier that writes a `Source` view to a ``ViewOutputKey``
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ViewOutputSourceModifier<
    Key: ViewOutputKey,
    Source: View
>: ViewModifier where Key.Content == Source {
    @usableFromInline
    var id: AnyHashable?
    @usableFromInline
    var source: Source

    @Namespace var namespace
    @UpdatePhase var phase

    @inlinable
    public init(
        _ key: Key.Type = Key.self,
        id: AnyHashable?,
        source: Source
    ) {
        self.id = id
        self.source = source
    }

    public func body(content: Content) -> some View {
        content
            .transformPreference(ViewOutputPreferenceKey<Key>.self) { value in
                ViewOutputPreferenceKey<Key>.reduce(value: &value) {
                    ViewOutputPreferenceKey<Key>.Value(
                        list: ViewOutputList<Key.Content>(
                            elements: [
                                ViewOutputList<Key.Content>.Element(
                                    id: namespace,
                                    explicitID: id,
                                    phase: phase,
                                    content: source
                                )
                            ]
                        )
                    )
                }
            }
    }
}

extension View {

    /// A modifier that writes a `Source` view to a ``ViewOutputKey``
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @inlinable
    public func viewOutput<
        Key: ViewOutputKey,
        Source: View
    >(
        _ : Key.Type,
        @ViewBuilder source: () -> Source
    ) -> some View where Key.Content == Source {
        modifier(
            ViewOutputSourceModifier(
                Key.self,
                id: nil,
                source: source()
            )
        )
    }

    /// A modifier that writes a `Source` view to a ``ViewOutputKey``
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @inlinable
    public func viewOutput<
        Key: ViewOutputKey,
        Source: View
    >(
        _ : Key.Type,
        @ViewBuilder source: () -> Source
    ) -> some View where Key.Content == AnyView {
        modifier(
            ViewOutputSourceModifier(
                Key.self,
                id: nil,
                source: AnyView(source())
            )
        )
    }
    
    /// A modifier that writes a `Source` view to a ``ViewOutputKey``
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @inlinable
    public func viewOutput<
        Key: ViewOutputKey,
        ID: Hashable,
        Source: View
    >(
        _ : Key.Type,
        id: ID,
        @ViewBuilder source: () -> Source
    ) -> some View where Key.Content == AnyView {
        modifier(
            ViewOutputSourceModifier(
                Key.self,
                id: id,
                source: AnyView(source())
            )
        )
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct ViewOutputPreferenceKey<
    Key: ViewOutputKey
>: PreferenceKey {

    struct Value: Equatable {
        var list = ViewOutputList<Key.Content>(elements: [])

        public static func == (lhs: Value, rhs: Value) -> Bool {
            guard lhs.list.count == rhs.list.count else {
                return false
            }
            for (lhs, rhs) in zip(lhs.list, rhs.list) {
                if lhs.id != rhs.id || lhs.phase != rhs.phase {
                    return false
                }
            }
            return true
        }

    }

    static var defaultValue: Value { .init() }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        Key.reduce(
            value: &value.list,
            nextValue: { nextValue().list }
        )
    }
}

/// A proxy to a ``ViewOutputKey.Value`` that must be read by ``ViewOutputKeyValueReader``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ViewOutputKeyValueProxy<Key: ViewOutputKey> {
    fileprivate var value: PreferenceKeyValueProxy<ViewOutputPreferenceKey<Key>>
}

/// A container view that resolves it's content from a ``ViewOutputKey``
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ViewOutputKeyReader<
    Key: ViewOutputKey,
    Content: View
>: View {

    public typealias Value = ViewOutputKeyValueProxy<Key>

    @usableFromInline
    var content: (Value) -> Content

    @inlinable
    public init(
        _ key: Key.Type,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        PreferenceKeyReader(ViewOutputPreferenceKey<Key>.self) { value in
            content(Value(value: value))
        }
    }
}

/// A container view that resolves it's content from a ``ViewOutputKey`` value
///
/// > Important: The ``ViewOutputKey`` value of `Content` is ignored
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ViewOutputKeyValueReader<
    Key: ViewOutputKey,
    Content: View
>: View {

    @usableFromInline
    var value: ViewOutputKeyValueProxy<Key>

    @usableFromInline
    var content: (ViewOutputList<Key.Content>) -> Content

    @inlinable
    public init(
        _ value: ViewOutputKeyValueProxy<Key>,
        @ViewBuilder content: @escaping (ViewOutputList<Key.Content>) -> Content
    ) {
        self.value = value
        self.content = content
    }

    public var body: some View {
        PreferenceKeyValueReader(value.value) { view in
            content(view.list)
        }
    }
}

// SwiftUIZ
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct _UnaryViewOutputKeyValueReader<
    Key: ViewOutputKey,
    ID: Hashable,
    Content: View
>: View {
    
    @usableFromInline
    var value: ViewOutputKeyValueProxy<Key>
    @usableFromInline
    var id: AnyHashable
    @usableFromInline
    var content: (ViewOutputList<Key.Content>.Subview) -> Content
    
    @inlinable
    public init(
        _ value: ViewOutputKeyValueProxy<Key>,
        id: AnyHashable,
        @ViewBuilder content: @escaping (ViewOutputList<Key.Content>.Subview) -> Content
    ) {
        self.value = value
        self.id = id
        self.content = content
    }
    
    public var body: some View {
        PreferenceKeyValueReader(value.value) { view in
            if let view = view.list.elementsByExplicitID[id] {
                content(view)
            }
        }
    }
}

// MARK: - Previews

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct ViewOutputKey_Previews: PreviewProvider {
    struct PreviewViewOutputKey: ViewOutputKey { }

    static var previews: some View {
        Preview()
    }

    struct Preview: View {
        @State var counter = 0

        var body: some View {
            ViewOutputKeyReader(PreviewViewOutputKey.self) { value in
                VStack {
                    ViewOutputKeyValueReader(value) { views in
                        ForEach(views) { view in
                            view
                        }
                    }
                }
                .viewOutput(PreviewViewOutputKey.self) {
                    Text("Hello, World")
                }
                .viewOutput(PreviewViewOutputKey.self) {
                    Button {
                        counter += 1
                    } label: {
                        Text(counter.description)
                    }
                }
            }
        }
    }
}
