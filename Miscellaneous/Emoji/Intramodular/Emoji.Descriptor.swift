//
// Copyright (c) Vatsal Manot
//

import Swift

extension Emoji {
    public struct Descriptor: Hashable {
        public var name: String
        public var shortName: String
        public var unified: String
        public var skinVariations: [Emoji.SkinVariation] = []
        public var category: Emoji.Category?
        public var subcategory: String?
        public var isObsoleted: Bool = false
        public var sortOrder: Int = 0
        
        public var emoji: String {
            return Self.getEmojiFor(unified: self.unified)
        }
        
        init(
            name: String,
            shortName: String,
            unified: String,
            skinVariations: [Emoji.SkinVariation] = [],
            category: Emoji.Category? = nil,
            subcategory: String?,
            isObsoleted: Bool = false,
            sortOrder: Int = 0
        ) {
            self.shortName = shortName
            self.unified = unified
            self.skinVariations = skinVariations
            self.name = name
            self.category = category
            self.subcategory = subcategory
            self.isObsoleted = isObsoleted
            self.sortOrder = sortOrder
        }
        
        static func getEmojiFor(unified: String) -> String {
            var emoji = ""
            
            unified.components(separatedBy: "-").forEach { unified in
                if let intValue = Int(unified, radix: 16), let unicode = UnicodeScalar(intValue) {
                    emoji += String(unicode)
                }
            }
            
            return emoji
        }
        
        func getEmojiWithSkinVariation(_ skinVariationType: Emoji.SkinVariationType) -> String {
            getEmojiWithSkinVariations([skinVariationType])
        }
        
        func getEmojiWithSkinVariations(_ skinVariationTypes: [Emoji.SkinVariationType]) -> String {
            if (skinVariationTypes.isEmpty) { return emoji }
            
            guard let skinVariation = self.skinVariations.first(where: { $0.skinVariationTypes == skinVariationTypes }) else { return emoji }
            
            let unifiedVariation = skinVariation.unified
            
            return Self.getEmojiFor(unified: unifiedVariation)
        }
    }
}
