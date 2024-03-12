//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

open class EmojiParser {
    fileprivate static var loading = false
    fileprivate static var emojiManager: EmojiDataReader = EmojiDataReader()
    fileprivate static var aliasMatchingRegex = try! NSRegularExpression(pattern: ":([\\w_+-]+)(?:(?:\\||::)((type_|skin-tone-\\d+)[\\w_]*))*:", options: .caseInsensitive)
    fileprivate static var aliasMatchingRegexOptionalColon: NSRegularExpression = try! NSRegularExpression(pattern: ":?([\\w_+-]+)(?:(?:\\||::)((type_|skin-tone-\\d+)[\\w_]*))*:?", options: .caseInsensitive)
    
    public static func prepare() {
        loading = true
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                loading = false
            }
        }
    }
    
    public static func getAliasesFromUnicode(_ unicode: String) -> [String] {
        let escapedUnicode = unicode.unicodeScalars.map { $0.escaped(asASCII: true) }
            .map { (escaped: String) -> String? in
                
                if (!escaped.hasPrefix("\\u{")) {
                    return escaped.unicodeScalars.map { (unicode: Unicode.Scalar) -> String in
                        
                        var hexValue = String(unicode.value, radix: 16).uppercased()
                        
                        while(hexValue.count < 4) {
                            hexValue = "0" + hexValue
                        }
                        
                        return hexValue
                    }.reduce("", +)
                }
                
                // Cleaning
                
                // format \u{XXXXX}
                var cleaned = escaped.dropFirst(3).dropLast()
                // removing unecessary 0s
                while (cleaned.hasPrefix("0") && cleaned.count > 4) {
                    cleaned = cleaned.dropFirst()
                }
                
                return String(cleaned)
                
            }
        
        if escapedUnicode.contains(where: { $0 == nil }) {
            return []
        }
        
        let unified = (escapedUnicode as! [String]).joined(separator: "-")
        
        return emojiManager.emojiForUnified[unified]?.map { $0.shortName } ?? []
    }
    
    public static func getUnicodeFromAlias(_ alias: String) -> String? {
        
        let input = alias as NSString
        
        let matches = aliasMatchingRegexOptionalColon.matches(in: alias, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: alias.count))
        
        if(matches.count == 0) {
            return nil
        }
        
        let match = matches[0]
        
        let aliasMatch = match.range(at: 1)
        let alias = input.substring(with: aliasMatch)
        
        let skinVariationsString = input.substring(from: aliasMatch.upperBound)
            .split(separator: ":")
            .map { $0.trimmingCharacters(in: [":"]) }
            .filter { !$0.isEmpty }
        
        guard let emojiObject = getEmojiFromAlias(alias) else { return nil }
        
        let emoji: String
        let skinVariations = skinVariationsString.compactMap {
            Emoji.SkinVariationType(rawValue: $0.uppercased()) ?? Emoji.SkinVariationType.getFromAlias($0.lowercased())
        }
        emoji = emojiObject.getEmojiWithSkinVariations(skinVariations)
        
        return emoji
    }
    
    public static func getEmojiFromUnified(_ unified: String) -> String {
        Emoji.Descriptor(name: "", shortName: "", unified: unified, subcategory: nil).emoji
    }
    
    static func getEmojiFromAlias(_ alias: String) -> Emoji.Descriptor? {
        
        guard let emoji = emojiManager.shortNameForUnified[alias] else { return nil }
        
        return emoji.first
    }
    
    public static func parseUnicode(_ input: String) -> String {
        
        return input
            .map {
                ($0, $0.unicodeScalars.map { $0.escaped(asASCII: true) })
            }
            .reduce("") { result, mapped in
                
                let fallback = mapped.0
                let unicode = mapped.1
                
                let maybeEmojiAlias = unicode.map { (escaped: String) -> String in
                    
                    if (!escaped.hasPrefix("\\u{")) {
                        return escaped
                    }
                    
                    // Cleaning
                    
                    // format \u{XXXXX}
                    var cleaned = escaped.dropFirst(3).dropLast()
                    // removing unecessary 0s
                    while (cleaned.hasPrefix("0")) {
                        cleaned = cleaned.dropFirst()
                    }
                    
                    return String(cleaned)
                    
                }.joined(separator: "-")
                
                let toDisplay: String
                
                if let emoji = emojiManager.emojiForUnified[maybeEmojiAlias]?.first {
                    toDisplay = ":\(emoji.shortName):"
                } else {
                    toDisplay = String(fallback)
                }
                
                return "\(result)\(toDisplay)"
            }
    }
    
    public static func parseAliases(_ input: String) -> String {
        
        var result = input
        
        getUnicodesForAliases(input).forEach { alias, emoji in
            if let emoji = emoji {
                result = result.replacingOccurrences(of: alias, with: emoji)
            }
        }
        
        return result
    }
    
    public static func getUnicodesForAliases(_ input: String) -> [(key: String, value: String?)] {
        let matches = aliasMatchingRegex.matches(in: input, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: input.count))
        
        if(matches.count == 0) {
            return []
        }
        
        let nsInput = input as NSString
        
        var uniqueMatches: [String:String?] = [:]
        
        matches.forEach {
            let fullAlias = nsInput.substring(with: $0.range(at: 0))
            
            if uniqueMatches.index(forKey: fullAlias) == nil {
                
                uniqueMatches[fullAlias] = getUnicodeFromAlias(fullAlias)
            }
            
        }
        
        return uniqueMatches.sorted(by: {
            $0.key.count > $1.key.count // Execute the longer first so emojis with skin variations are executed before the ones without
        })
    }
    
    public static var emojisByCategory: [Emoji.Category: [Emoji.Descriptor]]{
        return emojiManager.emojisForCategory
    }
    
    public static var emojisByUnicode: [String: Emoji.Descriptor] {
        return emojiManager.emojiForUnicode
    }
    
    public static func getEmojisForCategory(_ category: Emoji.Category) -> [String] {
        return (emojiManager.getEmojisForCategory(category) ?? []).map(\.emoji)
    }
}
