//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public protocol InterfaceModel: Identifiable where ID: InterfaceModelIdentifier {
    
}

public protocol InterfaceModelIdentifier: InterfaceModel, Hashable, Sendable where ID == Self {
    associatedtype Model: InterfaceModel
}

// MARK: - Implemented Conformances

extension _TypeAssociatedID: InterfaceModel where Parent: InterfaceModel {
    
}

extension _TypeAssociatedID: InterfaceModelIdentifier where Parent: InterfaceModel {
    public typealias Model = Parent
}
