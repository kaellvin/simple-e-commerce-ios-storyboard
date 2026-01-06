//
//  OptionValueDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct OptionValueDto: Decodable {
    let id: String
    let name: String
    let position: Int
    let option: OptionDto
}

extension OptionValueDto {
    func toDomain() -> OptionValue {
        return OptionValue(
            id: id,
            name: name,
            position: position,
            option: option.toDomain()
        )
    }
}
