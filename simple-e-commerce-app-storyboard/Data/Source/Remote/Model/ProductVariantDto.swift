//
//  ProductVariantDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductVariantDto: Decodable {
    let id: String
    let quantity: Int
    let price: String
    let variantImages: [ProductDetailImageDto]
    let variantOptions: [VariantOptionDto]
}

extension ProductVariantDto {
    func toDomain() -> ProductVariant {
        return ProductVariant(
            id: id,
            quantity: quantity,
            price: price,
            variantImages: variantImages.map { $0.toDomain() },
            variantOptions: variantOptions.map { $0.toDomain() }
        )
    }
}
