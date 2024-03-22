//
// Copyright (c) Vatsal Manot
//

import Foundation

enum MyPredicateValue: Hashable {
    case boolean(Bool)
    case string(String)
    case integer(Int)
    case float(Double)
}

enum MyPredicate: Hashable {
    case contains(MyPredicateValue)
    case isEqualTo(MyPredicateValue)
}

protocol MyPredicateTestable: Identifiable {
    func testPredicate(_ predicate: MyPredicate) -> Bool
}

extension MyPredicateTestable {
    func testPredicates(_ predicates: [MyPredicate]) -> Bool {
        for predicate in predicates {
            guard testPredicate(predicate) else {
                return false
            }
        }
        
        return true
    }
}

struct MyPredicatedStuff<T> {
    struct Match {
        let id: Int
        let value: T
    }
    
    var stuff: [[MyPredicate]: Match]
    
    func matches(for x: any MyPredicateTestable) -> [Match] {
        var result: [Match] = []
        
        for (predicates, match) in stuff {
            if x.testPredicates(predicates) {
                result.append(match)
            }
        }
        
        return result
    }
}
