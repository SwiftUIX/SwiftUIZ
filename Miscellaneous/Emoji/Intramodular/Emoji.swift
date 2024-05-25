//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct Emoji: Hashable, RawRepresentable, Sendable {
    public let rawValue: String
        
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Emoji: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

// MARK: - Conformances

extension Emoji: CaseIterable {
    public static let allCases: [Emoji] = {
        Array(EmojiDataReader.shared.emojis.lazy.map({ Self(rawValue: $0.emoji)! }).distinct())
    }()
}

extension Emoji: Codable {
    public init(from decoder: Decoder) throws {
        let emoji = try Emoji(rawValue: RawValue(from: decoder)).unwrap()
        
        self = emoji
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension Emoji: Identifiable {
    public var id: some Hashable {
        rawValue
    }
}

extension Emoji: Named {
    public var name: String {
        GitHubEmojiDataReader.data[self]?.description ?? descriptor.name
    }
}

// MARK: - Auxiliary

extension Emoji {
    public init?(descriptor: Emoji.Descriptor) {
        self.init(rawValue: descriptor.emoji)
    }
    
    public var descriptor: Emoji.Descriptor {
        Emoji.Descriptor(emoji: self)
    }
}

extension Emoji.Descriptor {
    public init!(emoji: Emoji) {
        guard let descriptor = EmojiDataReader.shared.emojiForUnicode[emoji.rawValue] else {
            return nil
        }
        
        self = descriptor
    }
}

// MARK: - SwiftUI Additions

#if canImport(SwiftUI)
import SwiftUI

extension Text {
    @_disfavoredOverload
    public init(_ emoji: Emoji) {
        self.init(emoji.rawValue)
    }
}
#endif
