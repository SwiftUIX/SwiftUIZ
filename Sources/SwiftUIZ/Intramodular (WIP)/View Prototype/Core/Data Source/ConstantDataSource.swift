//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct ConstantDataSource<Subject>: DataSource {
    public let subject: Subject
    
    public init(subject: Subject) {
        self.subject = subject
    }
    
    public var body: some DataSource {
        _UnsafeViewToDataSourceAdaptor {
            EmptyView()
        }
    }
}
