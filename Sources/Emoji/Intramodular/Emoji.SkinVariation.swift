//
// Copyright (c) Vatsal Manot
//

import Swift

extension Emoji {
    public struct SkinVariation: Hashable {
        public var unified: String
        public var skinVariationTypes: [SkinVariationType]
        
        public init(unified: String, skinVariations: [SkinVariationType]) {
            self.unified = unified
            self.skinVariationTypes = skinVariations
        }
    }
}

extension Emoji {
    public enum SkinVariationType: String, CaseIterable, Hashable {
        case TYPE_1_2 = "TYPE_1_2"
        case TYPE_3 = "TYPE_3"
        case TYPE_4 = "TYPE_4"
        case TYPE_5 = "TYPE_5"
        case TYPE_6 = "TYPE_6"
        
        func getUnifiedValue() -> String {
            switch self {
                case .TYPE_1_2:
                    return "1F3FB"
                case .TYPE_3:
                    return "1F3FC"
                case .TYPE_4:
                    return "1F3FD"
                case .TYPE_5:
                    return "1F3FE"
                case .TYPE_6:
                    return "1F3FF"
            }
        }
        
        func getAliasValue() -> String {
            switch self {
                case .TYPE_1_2:
                    return "skin-tone-2"
                case .TYPE_3:
                    return "skin-tone-3"
                case .TYPE_4:
                    return "skin-tone-4"
                case .TYPE_5:
                    return "skin-tone-5"
                case .TYPE_6:
                    return "skin-tone-6"
            }
        }
        
        static func getFromUnified(_ unified: String) -> [SkinVariationType] {
            let splitUnified = Set(unified.split(separator: "-").map(String.init))
            
            return allCases.filter({ splitUnified.contains($0.getUnifiedValue()) })
        }
        
        static func getFromAlias(_ unified: String) -> SkinVariationType? {
            return self.allCases.first(where: { $0.getAliasValue() == unified.lowercased() })
        }
    }
}
