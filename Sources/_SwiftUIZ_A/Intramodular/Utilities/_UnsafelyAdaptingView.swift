//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _UnsafelyAdaptingView: View {
    associatedtype _UnsafeBody: View
    
    var _unsafeBody: _UnsafeBody { get }
}
