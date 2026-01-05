//
//  ProductDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 04/01/2026.
//

import Foundation

struct ProductDto: Decodable {
    let id: String
    let name: String
    let defaultVariant: DefaultVariantDto
    let productImages: [ProductImageDto]
    
    //NOTE
    //    enum CodingKeys: String, CodingKey {
    //        case id
    //        case name
    //        case defaultVariant
    //        case testProductImages = "productImages"
    //    }
}


extension ProductDto {
    func toDomain() -> Product {
        return Product(
            id: id,
            name: name,
            price: defaultVariant.price,
            imageUrl: productImages.first?.url ?? ""
        )
    }
}
