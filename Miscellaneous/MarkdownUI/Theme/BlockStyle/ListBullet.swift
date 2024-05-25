import SwiftUI

struct ListBullet: View {
    private let image: Image
    
    var body: some View {
        TextStyleAttributesReader { attributes in
            let fontSize = attributes.fontProperties?.scaledSize ?? FontProperties.defaultSize
            
            self.image.font(.system(size: round(fontSize / 3)))
        }
    }
}

extension ListBullet {
    static var disc: Self {
        Self(image: .init(systemName: "circle.fill"))
    }
    
    static var circle: Self {
        Self(image: .init(systemName: "circle"))
    }
    
    static var square: Self {
        Self(image: .init(systemName: "square.fill"))
    }
}
