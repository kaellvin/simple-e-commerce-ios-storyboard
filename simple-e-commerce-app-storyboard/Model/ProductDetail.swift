//
//  ProductDetail.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductDetail {
    let id: String
    let name: String
    let description: String
    let defaultVariantId: String
    let productVariants: [ProductVariant]
    let productImageUrls: [String]
    let productOptions: [ProductOption]
    let optionValueImages: [OptionValueImage]
    
}
