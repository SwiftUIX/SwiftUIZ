//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _PrimitiveViewPrototype: ViewPrototype {
     
}

extension _PrimitiveViewPrototype  {
    public var body: some ViewPrototype {
        _PushViewPrototypeExpression(self)
    }
}

public struct _ViewPrototypeResolutionContext {
    
}

public struct _ViewPrototypeResolution {
    
}

public enum _PrimitiveViewPrototypes {
    public struct RenderView: _PrimitiveViewPrototype {
        let content: any View
    }
}
