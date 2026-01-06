//
//  ProductOptionDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductOptionDto: Decodable {
    let optionId: String
    let position: Int
}

extension ProductOptionDto {
    func toDomain() -> ProductOption {
        return ProductOption(
            optionId: optionId,
            position: position
        )
    }
}
