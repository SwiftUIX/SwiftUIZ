//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct _PrintMirrorView: View {
    public let value: Any
    
    public init(reflecting value: Any) {
        self.value = _unwrapPossiblyOptionalAny(value)
    }
    
    public var body: some View {
        Form {
            List {
                Content(reflecting: value)
            }
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension _PrintMirrorView {
    struct Content: View {
        let value: Any
        
        init(reflecting value: Any) {
            self.value = value
        }
        
        var body: some View {
            let mirror = Mirror(reflecting: value)
            
            OutlineGroup(
                mirror._children,
                children: \.children
            ) { item in
                Cell(item: item).contextMenu {
                    Button("Dump \(item.label ?? "thefuck")") {
                        dump(item.value)
                    }
                }
            }
        }
    }
}

extension _PrintMirrorView {
    fileprivate struct Cell: View {
        let item: _MirrorChild
        
        var body: some View {
            Group {
                if Mirror(reflecting: item.value).children.count <= 1 {
                    LabeledContent {
                        InlineMirrorChild(item: item)
                    } label: {
                        NavigationLink  {
                            _PrintMirrorView(reflecting: _unwrapPossiblyOptionalAny(item.value))
                        } label: {
                            label
                        }
                    }
                } else {
                    NavigationLink {
                        _PrintMirrorView(reflecting: _unwrapPossiblyOptionalAny(item.value))
                    } label: {
                        label
                    }
                }
            }
        }
        
        var label: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.typeName)
                        .font(.headline.weight(.medium))
                        .padding(.extraSmall)
                        .border(HierarchicalShapeStyle.tertiary, cornerRadius: 4)
                    
                    Text(verbatim: item.label ?? "unknown")
                        .font(.body)
                }
                
                Text("\(item.children.count) children")
                    .font(.footnote)
            }
        }
    }
    
    fileprivate struct InlineMirrorChild: View {
        let item: _MirrorChild
        
        var body: some View {
            let mirror = Mirror(reflecting: item.value)
            
            if mirror.displayStyle == .collection {
                ForEach(mirror._children) { element in
                    InlineMirrorChild(item: element)
                }
            } else {
                Text(verbatim: item.inlineValueDescription)
            }
        }
    }
}

// MARK: - Auxiliary

extension Mirror {
    fileprivate var typeNamePrefix: String? {
        guard let displayStyle else {
            return nil
        }
        
        switch displayStyle {
            case .struct:
                return "S"
            case .class:
                return "C"
            case .enum:
                return "E"
            case .tuple:
                return "(...)"
            case .optional:
                return nil
            case .collection:
                return "[...]"
            case .dictionary:
                return "[:]"
            case .set:
                return "[...]"
            @unknown default:
                assertionFailure()
                
                return nil
        }
    }
}

fileprivate struct _MirrorChild: Identifiable {
    let base: Mirror.Child
    let typeName: String
    
    public init(
        base: Mirror.Child
    ) {
        self.base = base
        self.typeName = _getSanitizedTypeName(
            from: Swift.type(of: base.value),
            qualified: false,
            genericsAbbreviated: true
        )
    }
    
    var id: AnyHashable {
        base.label
    }
    
    var label: String? {
        base.label
    }
    
    var value: Any {
        base.value
    }
    
    var inlineValueDescription: String {
        guard let value = Optional(_unwrapping: value) else {
            return "nil"
        }
        
        let description = String(describing: value)
        
        return description
    }
    
    var children: AnyRandomAccessCollection<_MirrorChild> {
        Mirror(reflecting: base.value)._children
    }
}

extension Mirror {
    fileprivate var _children: AnyRandomAccessCollection<_MirrorChild> {
        AnyRandomAccessCollection(children.lazy.map({ _MirrorChild(base: $0) }))
    }
}
