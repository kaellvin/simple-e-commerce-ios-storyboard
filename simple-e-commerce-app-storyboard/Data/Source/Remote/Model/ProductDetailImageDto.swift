//
//  ProductDetailImageDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductDetailImageDto: Decodable {
    let url: String
    let position: Int
    let isPrimary: Bool
}

extension ProductDetailImageDto {
    func toDomain() -> ProductDetailImage {
        return ProductDetailImage(
            url: url,
            position: position,
            isPrimary: isPrimary
        )
    }
}
