//
// Copyright (c) Vatsal Manot
//

import Swallow

extension Emoji {
    public enum Category: String, CaseIterable, Codable, Hashable {
        case symbols = "Symbols"
        case objects = "Objects"
        case animalsAndNature = "Animals & Nature"
        case people = "People & Body"
        case foodAndDrink = "Food & Drink"
        case places = "Travel & Places"
        case activities = "Activities"
        case flags = "Flags"
        case smileysAndEmotion = "Smileys & Emotion"
    }
}

// MARK: - Conformances

extension Emoji.Category: Identifiable {
    public var id: some Hashable {
        rawValue
    }
}

extension Emoji.Category: Named {
    public var name: String {
        rawValue
    }
}
