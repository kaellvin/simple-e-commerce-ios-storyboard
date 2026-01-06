//
//  ProductVariantOptionModels.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct PVOption: Identifiable {
    let id: String
    let name: String
    let publicLabel: String
    var values: [SelectablePVOptionValue]
}

struct SelectablePVOptionValue {
    var imageUrl: String
    let optionValue: PVOptionValue
    var isSelected: Bool
    var isWithinSelection: Bool
}

struct PVOptionValue: Identifiable {
    let id: String
    let name: String
    let position: Int
}

struct ChipTag {
    let pvOptionId: String
    let optionValue: PVOptionValue
}
