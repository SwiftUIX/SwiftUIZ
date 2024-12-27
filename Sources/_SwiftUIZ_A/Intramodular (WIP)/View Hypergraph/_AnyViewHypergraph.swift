//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwallowMacrosClient
import SwiftUIX

public protocol _AnyViewHypergraphType: _AnyViewHypergraph {
    var _isInvalidInstance: Bool { get }
    
    subscript(_ id: _AnyViewHypergraph.InterposeID) -> any _AnyViewHypergraph.InterposeProtocol { get }
    
    func prepare(_: some _AnyViewHypergraph.InterposeProtocol) throws
    
    func insert(_: any _AnyViewHypergraph.InterposeProtocol)
    func remove(_: any _AnyViewHypergraph.InterposeProtocol)
    
    init()
}

@objc
open class _AnyViewHypergraph: NSObject, ObservableObject {
    public let _isInvalidInstance: Bool
    
    public required init(invalid: ()) {
        self._isInvalidInstance = true
        
        super.init()
    }
    
    public required override init() {
        self._isInvalidInstance = false
        
        super.init()
    }
}

public final class _InvalidViewHypergraph: _AnyViewHypergraph, _AnyViewHypergraphType {
    public subscript(
        id: _AnyViewHypergraph.InterposeID
    ) -> any _AnyViewHypergraph.InterposeProtocol {
        fatalError(.unimplemented)
    }
    
    public func prepare(
        _: some _AnyViewHypergraph.InterposeProtocol
    ) throws {
        
    }
    
    public func insert(
        _: any _AnyViewHypergraph.InterposeProtocol
    ) {
        
    }
    
    public func remove(
        _: any _AnyViewHypergraph.InterposeProtocol
    ) {
        
    }
}

// MARK: - WIP

extension _AnyViewHypergraph {
    public struct _ViewTypeDescription: _HeavyweightViewHypergraphPassTarget {
        public struct Demands: Initiable { // FIXME
            public var _swiftType: Any.Type?
            
            public init() {
                
            }
        }
        
        public var demands: [_AnyViewHypergraph.AnySymbol: Demands] = [:]
        
        public init() {
            
        }
    }
}
