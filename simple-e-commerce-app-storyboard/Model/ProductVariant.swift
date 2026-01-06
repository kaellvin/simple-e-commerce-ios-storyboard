//
//  ProductVariant.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductVariant {
    var id: String = ""
    var quantity: Int = -1
    var price: String = ""
    var variantImages: [ProductDetailImage] = []
    var variantOptions: [VariantOption] = []
    
    static let empty = ProductVariant()
}
