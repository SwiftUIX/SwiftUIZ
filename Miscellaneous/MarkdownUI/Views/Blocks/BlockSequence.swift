//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwallowMacrosClient
import SwiftUI
private import SwiftUIX

@Singleton
class BlockSequenceCache: ObservableObject {
    private var blocksMarginsByData: [Int: [Int: _BlockMargin]] = [:]
    
    subscript<Data: Hashable & RandomAccessCollection>(
        marginsFor index: Data.Index,
        in data: Data
    ) -> _BlockMargin {
        get {
            self.blocksMarginsByData[data.hashValue, default: [:]][data.distance(from: data.startIndex, to: index), default: _BlockMargin()]
        } set {
            var blockMargins = self.blocksMarginsByData
            
            let oldValue = blockMargins[data.hashValue, defaultInPlace: [:]].updateValue(newValue, forKey: data.distance(from: data.startIndex, to: index))
                        
            if oldValue != newValue {
                objectWillChange.send()

                self.blocksMarginsByData = blockMargins
            }
        }
    }
}

struct BlockSequence<Data: Hashable & RandomAccessCollection, Content>: View where Data.Element: Hashable, Data.Index: Hashable, Content: View {
    struct Item: Hashable, Identifiable {
        let index: Data.Index
        let element: Data.Element
        
        var id: AnyHashable {
            Hashable2ple((index, element))
        }
    }
    
    @Environment(\.multilineTextAlignment) private var textAlignment
    
    private let data: Data
    private let items: [Item]
    private let content: (Data.Index, Data.Element) -> Content
    
    init(
        _ data: Data,
        @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content
    ) {
        self.data = data
        self.items = data._enumerated().map({ Item(index: $0.0, element: $0.1) })
        self.content = content
    }
    
    var body: some View {
        ForEach(items) { (item: Item) in
            TopPadding(data: data, item: item)
                .equatable()
                .accessibilityHidden(true)
            
            self.content(item.index, item.element)
                .onPreferenceChange(BlockMarginsPreference.self) { (value: _BlockMargin) in
                    BlockSequenceCache.shared[marginsFor: item.index, in: data] = value
                }
                .preference(key: BlockMarginsPreference.self, value: .unspecified)
        }
    }
    
    struct TopPadding: Equatable, View {
        @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
        
        @ObservedObject private var cache: BlockSequenceCache = .shared
        
        let data: Data
        let item: Item
        
        var body: some View {
            let height: CGFloat = self.topPaddingLength() ?? 0
            
            Rectangle()
                .frame(width: 0, height: height)
                .allowsHitTesting(false)
                .hidden()
        }
        
        private func topPaddingLength() -> CGFloat? {
            guard item.index > data.startIndex else {
                return 0
            }
            
            let topSpacing: CGFloat = cache[marginsFor: item.index, in: data].top ?? 0
            let predecessor: Data.Index = data.index(before: item.index)
            let predecessorBottomSpacing: CGFloat = (self.tightSpacingEnabled ? 0 : cache[marginsFor: predecessor, in: data].top) ?? 0
            
            return [topSpacing, predecessorBottomSpacing]
                .compactMap({ $0 })
                .max()
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.item == rhs.item
        }
    }
}

extension BlockSequence where Data == [BlockNode], Content == EquatableView<BlockNode> {
    init(_ blocks: [BlockNode]) {
        self.init(blocks) {
            $1.equatable()
        }
    }
}

extension TextAlignment {
    var alignment: Alignment {
        switch self {
            case .leading:
                return .leading
            case .center:
                return .center
            case .trailing:
                return .trailing
        }
    }
}
