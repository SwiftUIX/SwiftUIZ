//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _DataSourceExpression: Hashable {
    @_HashableExistential
    public var type: any DataSource.Type
}
