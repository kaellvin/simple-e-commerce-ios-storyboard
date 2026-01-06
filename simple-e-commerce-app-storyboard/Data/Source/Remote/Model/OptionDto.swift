//
//  OptionDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct OptionDto: Decodable {
    let id: String
    let name: String
    let publicLabel: String
}

extension OptionDto {
    func toDomain() -> Option {
        return Option(
            id: id,
            name: name,
            publicLabel: publicLabel
        )
    }
}
