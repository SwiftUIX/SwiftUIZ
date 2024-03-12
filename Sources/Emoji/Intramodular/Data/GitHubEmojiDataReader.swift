//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public struct GitHubEmojiEntry: Codable, Hashable, Identifiable {
    public let emoji: String
    public let description: String
    public let category: Emoji.Category
    public let aliases: [String]
    public let tags: [String]
    public let unicodeVersion: String
    public let iosVersion: String
    public var skinTones: Bool?
    
    public var id: some Hashable {
        emoji
    }
    
    public init?(from emoji: Emoji) {
        guard let entry = GitHubEmojiDataReader.data[emoji] else {
            return nil
        }
        
        self = entry
    }
}

struct GitHubEmojiDataReader {
    public static var data: [Emoji: GitHubEmojiEntry] = readData()
    
    static func readData() -> [Emoji: GitHubEmojiEntry] {
        do {
            let decoder = JSONDecoder()
            let path = Bundle.module.path(forResource: "gemoji", ofType: "json")!
            let entriesData = try FileManager.default.contents(atPath: path).unwrap()
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let entries = try decoder.decode([GitHubEmojiEntry].self, from: entriesData).map {
                (Emoji(rawValue: $0.emoji)!, $0)
            }
            
            return Dictionary(
                entries,
                uniquingKeysWith: { lhs, rhs in lhs }
            )
        } catch {
            assertionFailure()
            
            return [:]
        }
    }
}
