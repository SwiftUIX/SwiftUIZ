//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct ConsumeProxy<Subject> {
    public var subject: Subject {
        fatalError()
    }
}

extension ViewPrototypeBuilder {
    public struct Consume<Data, Content: ViewPrototype>: ViewPrototype {
        public let content: (ConsumeProxy<Data>) -> Content
        
        public init(
            _ data: Data.Type,
            @ViewBuilder content: @escaping (ConsumeProxy<Data>) -> Content
        ) {
            self.content = content
        }
        
        public init<V: View>(
            _ data: Data.Type,
            @ViewBuilder content: @escaping (ConsumeProxy<Data>) -> V
        ) where Content == ViewPrototypeBuilder.RenderView<V> {
            self.content = {
                ViewPrototypeBuilder.RenderView(content: content($0))
            }
        }
        
        public var body: some ViewPrototype {
            _ModifyViewPrototype { prototype in
                prototype.merge(_UnresolvedViewDemands.Consume())
            }
        }
    }
}

// MARK: - Supplementary

extension ViewPrototype {
    public typealias Consume<Data, Content: ViewPrototype> = ViewPrototypeBuilder.Consume<Data, Content>
}
