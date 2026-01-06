//
//  VariantOptionDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct VariantOptionDto: Decodable {
    let productVariantId: String
    let optionValueId: String
    let optionValue: OptionValueDto
}

extension VariantOptionDto {
    func toDomain() -> VariantOption {
        return VariantOption(
            productVariantId: productVariantId,
            optionValueId: optionValueId,
            optionValue: optionValue.toDomain()
        )
    }
}
