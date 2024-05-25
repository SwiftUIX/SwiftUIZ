//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI
private import SwiftUIX

struct BlockSequence<Data: RandomAccessCollection, Content>: View where Data.Element: Hashable, Data.Index: Hashable, Content: View {
    @Environment(\.multilineTextAlignment) private var textAlignment
    @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
    
    @State private var blockMargins: [Data.Index: _BlockMargin] = [:]
    
    private let data: Data
    private let content: (Data.Index, Data.Element) -> Content
    
    init(
        _ data: Data,
        @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(
            Array(data._enumerated()),
            id: \.0
        ) { (index, element) in
            self.content(index, element)
                .onPreferenceChange(BlockMarginsPreference.self) { value in
                    self.blockMargins[index] = value
                }
                .preference(key: BlockMarginsPreference.self, value: .unspecified)
                .padding(.top, self.topPaddingLength(for: element, at: index))
        }
    }
    
    private func topPaddingLength(
        for element: Data.Element,
        at index: Data.Index
    ) -> CGFloat? {
        guard index > data.startIndex else {
            return 0
        }
        
        let topSpacing: CGFloat = self.blockMargins[index]?.top ?? 0
        let predecessor = data.index(before: index)
        let predecessorBottomSpacing: CGFloat = (self.tightSpacingEnabled ? 0 : self.blockMargins[predecessor]?.bottom) ?? 0
        
        return [topSpacing, predecessorBottomSpacing]
            .compactMap({ $0 })
            .max()
    }
}

extension BlockSequence where Data == [BlockNode], Content == BlockNode {
    init(_ blocks: [BlockNode]) {
        self.init(blocks) {
            $1
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
