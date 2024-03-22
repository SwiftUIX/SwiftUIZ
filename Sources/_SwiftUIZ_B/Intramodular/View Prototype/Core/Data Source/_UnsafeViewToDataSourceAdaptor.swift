//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _UnsafeViewToDataSourceAdaptor<Content: View>: DataSource {
    public let content: Content
    
    public init(content: Content) {
        self.content = content
    }
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: Never {
        fatalError()
    }
    
    @_transparent
    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        Content._makeView(view: view[\.content], inputs: inputs)
    }
    
    @_transparent
    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        Content._makeViewList(view: view[\.content], inputs: inputs)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @_transparent
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        Content._viewListCount(inputs: inputs)
    }
}
