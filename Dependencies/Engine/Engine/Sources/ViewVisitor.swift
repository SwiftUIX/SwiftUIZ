//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import EngineCore

/// A ``ViewVisitor`` allows for `some View` to be unwrapped
/// to visit the concrete `View` type.
public typealias ViewVisitor = EngineCore.ViewVisitor

/// A protocol to statically define a descriptor to a type's metadata
///
/// A ``TypeDescriptor`` can be used alongside a visitor to safely
/// visit a type. For example, the ``ViewProtocolDescriptor`` can
/// be used with a ``ViewVisitor``:
///
///     func makeUIHostingController(content: Any) -> UIViewController? {
///         func project<Content>(_ content: Content) -> UIViewController? {
///             guard let conformance = ViewProtocolDescriptor.conformance(of: Content.self)
///             else {
///                 return nil
///             }
///             var visitor = Visitor(input: content)
///             conformance.visit(visitor: &visitor)
///             return visitor.output
///         }
///         return _openExistential(content, do: project)
///     }
///
///     private struct Visitor<Input>: ViewVisitor {
///         var input: Input
///         var output: UIViewController!
///
///         mutating func visit<Content>(type: Content.Type) where Content: View {
///             output = UIHostingController(rootView: unsafeBitCast(input, to: Content.self))
///         }
///     }
///     
public typealias TypeDescriptor = EngineCore.TypeDescriptor

/// The ``TypeDescriptor`` for the `View` protocol
public typealias ViewProtocolDescriptor = EngineCore.ViewProtocolDescriptor

#if os(iOS) || os(tvOS)

/// The ``TypeDescriptor`` for the `UIViewRepresentable` protocol
public typealias UIViewRepresentableProtocolDescriptor = EngineCore.UIViewRepresentableProtocolDescriptor

/// The ``TypeDescriptor`` for the `UIViewControllerRepresentable` protocol
public typealias UIViewControllerRepresentableProtocolDescriptor = EngineCore.UIViewControllerRepresentableProtocolDescriptor

#endif

#if os(macOS)

/// The ``TypeDescriptor`` for the `NSViewRepresentable` protocol
public typealias NSViewRepresentableProtocolDescriptor = EngineCore.NSViewRepresentableProtocolDescriptor

/// The ``TypeDescriptor`` for the `NSViewControllerRepresentable` protocol
public typealias NSViewControllerRepresentableProtocolDescriptor = EngineCore.NSViewControllerRepresentableProtocolDescriptor

#endif
