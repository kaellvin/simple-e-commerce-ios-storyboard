//
//  OptionValueImageDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct OptionValueImageDto: Decodable{
    let productId: String
    let url: String
    let optionValueId: String
}

extension OptionValueImageDto {
    func toDomain() -> OptionValueImage {
        return OptionValueImage(
            productId: productId,
            url: url,
            optionValueId: optionValueId)
    }
}
