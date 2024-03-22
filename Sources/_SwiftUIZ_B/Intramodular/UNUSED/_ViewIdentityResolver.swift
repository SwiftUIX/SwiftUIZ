//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

class _ViewIdentityResolver: ObservableObject {
    enum StateFlag {
        case resolutionRequested
        case resolutionInProgress
        case isDirty
    }
    
    var stateFlags: Set<StateFlag> = []
    var _lastValidResolution: _ViewIdentity.Resolved?
    var _identityStateBinding: Binding<_ViewIdentityState>?
    
    var identityState: _ViewIdentityState {
        get {
            _identityStateBinding!.wrappedValue
        } set {
            DispatchQueue.main.async {
                self._identityStateBinding!.wrappedValue = newValue
            }
        }
    }
    
    @Published private var generation: Int = 0 {
        didSet {
            identityState.generation = generation
        }
    }
    
    var _resolution: _ViewIdentity.Resolved? {
        willSet {
            if newValue != _resolution, !stateFlags.contains(.resolutionInProgress) {
                objectWillChange.send()
            }
        }
        
        didSet {
            if oldValue != _resolution {
                stateFlags.insert(.isDirty)
            }
            
            assert(stateFlags.contains(.resolutionInProgress))
        }
    }
    
    init() {
        
    }
    
    var resolution: _ViewIdentity.Resolved? {
        get {
            if stateFlags.contains(.resolutionInProgress) {
                return _lastValidResolution
            }
            
            return _resolution
        }
    }
    
    private var _beginCount: Int = 0
    
    func begin() {
        assert(_beginCount >= 0)
        
        stateFlags.insert(.resolutionInProgress)
        stateFlags.remove(.resolutionRequested)
        
        _beginCount += 1
    }
    
    func end() {
        assert(_beginCount >= 0)
        
        _beginCount -= 1
        
        if _beginCount == 0 {
            stateFlags.remove(.resolutionInProgress)
        }
                
        assert(!stateFlags.contains(.resolutionRequested))
        
        cleanUp()
    }
    
    private func cleanUp() {
        guard _beginCount == 0, stateFlags.contains(.isDirty) else {
            return
        }
        
        self._lastValidResolution = _resolution
        
        identityState.surfaceGeneration += 1
        
        stateFlags.remove(.isDirty)
    }
    
    func setNeedsPass() {
        guard !stateFlags.contains(.resolutionInProgress) else {
            assertionFailure()
            
            return
        }
        
        guard !stateFlags.contains(.resolutionRequested) else {
            return
        }
        
        generation += 1
        
        stateFlags.insert(.resolutionRequested)
    }
}
