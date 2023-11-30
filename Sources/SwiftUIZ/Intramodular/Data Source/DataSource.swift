//
// Copyright (c) Vatsal Manot
//

import Swallow

/// An abstract representation of a view's data source.
public protocol DataSource: View where Body: DataSource {
    var body: Body { get }
}

public protocol _ForEachContentToDataSourceAdaptorType: DataSource {
    
}

extension ForEach {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>) where Content == _ArbitraryDataToDataSourceAdaptor<Data> {
        self.init(data, id: id) { content in
            _ArbitraryDataToDataSourceAdaptor(data: data)
        }
    }
}

public struct _ArbitraryDataToDataSourceAdaptor<Data>: DataSource {
    public let data: Data
    
    public var body: some DataSource {
        _UnsafeViewToDataSourceAdaptor(content: _UnimplementedView())
    }
}

public struct _ForEachContentToDataSourceAdaptor<Content: DataSource>: DataSource {
    public let content: Content
    
    public var body: _UnsafeViewToDataSourceAdaptor<Content> {
        _UnsafeViewToDataSourceAdaptor(content: content)
    }
}

extension ForEach: DataSource where Content: _ForEachContentToDataSourceAdaptorType {
    public var body: Never {
        fatalError()
    }
}

public struct _UnsafeViewToDataSourceAdaptor<Content: View>: DataSource {
    public let content: Content
    
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

extension Never: DataSource {
    
}
