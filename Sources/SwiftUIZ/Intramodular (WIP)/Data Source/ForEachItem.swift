//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct ForEachItem<Data> {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
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

public protocol _ForEachContentToDataSourceAdaptorType: DataSource {
    
}

extension ForEach {
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>
    ) where Content == _ArbitraryDataToDataSourceAdaptor<Data> {
        self.init(data, id: id) { content in
            _ArbitraryDataToDataSourceAdaptor(data: data)
        }
    }
}

extension ForEach: DataSource where Content: _ForEachContentToDataSourceAdaptorType {
    public var body: Never {
        fatalError()
    }
}
