//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _ListSelectionBindingController<Data: RandomAccessCollection, Selection> where Data.Element: Identifiable, Data.Element == Selection {
    let data: Data
    let selection: Binding<Selection.ID?>
    let indexOfElement: (Data.Element.ID) -> Data.Index?
    
    var selectedIndex: Data.Index? {
        get {
            selection.wrappedValue.flatMap({ indexOfElement($0) })
        } nonmutating set {
            if let newValue {
                selection.wrappedValue = data[newValue].id
            } else {
                selection.wrappedValue = nil
            }
        }
    }
    
    var selectedOffset: Int? {
        get {
            selectedIndex.map({ data.distance(from: data.startIndex, to: $0) })
        } nonmutating set {
            selectedIndex = newValue.map({ data.index(data.startIndex, offsetBy: $0) })
        }
    }
    
    public init(data: Data, selection: Binding<Selection.ID?>) {
        self.data = data
        self.selection = selection
        self.indexOfElement = { id in
            data.firstIndex(where: { $0.id == id })
        }
    }
    
    public init(
        data: Data,
        selection: Binding<Selection.ID?>
    ) where Data == IdentifierIndexingArrayOf<Selection> {
        self.data = data
        self.selection = selection
        self.indexOfElement = { id in
            data.index(ofElementIdentifiedBy: id)
        }
    }
    
    public func increment(by n: Int = 0) {
        guard !data.isEmpty else {
            selectedOffset = nil
            
            return
        }
        
        selectedOffset = min((selectedOffset ?? -1) + n, (data.count - 1).absoluteValue)
    }
     
    public func decrement(by n: Int = 1) {
        guard !data.isEmpty else {
            selectedOffset = nil
            
            return
        }

        selectedOffset = max((selectedOffset ?? 0) - n, 0)
    }
}

#if !os(tvOS)
extension _ListSelectionBindingController {
    @discardableResult
    public func move(
        _ direction: _SwiftUIX_MoveCommandDirection
    ) -> _SwiftUIX_KeyPress.Result {
        switch direction {
            case .left:
                return .ignored
            case .right:
                return .ignored
            case .down:
                increment(by: 1)
                
                return .handled
            case .up:
                decrement(by: 1)
                
                return .handled
        }
    }
}
#endif

/*public struct KeyboardNavigatedGridIndex {
    public enum KeyboardEvent {
        case left
        case right
        case down
        case up
    }
    
    public let dataCount: Int
    public let columnCount: Int
    
    public var index: Int?
    
    public init(
        dataCount: Int,
        columnCount: Int = 1,
        value: Int? = nil
    ) {
        self.dataCount = dataCount
        self.columnCount = columnCount
        
        if let value = value, dataCount != 0,( 0..<dataCount).contains(value) {
            self.index = value
        }
    }
    
    public mutating func process(_ event: KeyboardEvent) {
        switch event {
            case .left:
                guard columnCount > 1 else {
                    return
                }
                
                decrement(by: 1)
            case .right:
                guard columnCount > 1 else {
                    return
                }
                
                increment(by: 1)
            case .down:
                if columnCount == 1 {
                    increment(by: 1)
                } else {
                    increment(by: columnCount)
                }
            case .up:
                if columnCount == 1 {
                    decrement(by: 1)
                } else {
                    decrement(by: columnCount)
                }
        }
    }
    
    public mutating func increment(by n: Int) {
        index = min((index ?? -1) + n, (dataCount - 1).absoluteValue)
    }
    
    public mutating func decrement(by n: Int) {
        index = max((index ?? 0) - n, 0)
    }
}
*/
