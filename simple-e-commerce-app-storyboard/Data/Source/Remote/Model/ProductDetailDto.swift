//
//  ProductDetailDto.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

struct ProductDetailDto: Decodable {
    let id: String
    let name: String
    let description: String
    let defaultVariant: ProductDetailDefaultVariantDto
    let productVariants: [ProductVariantDto]
    let productImages: [ProductDetailImageDto]
    let productOptions: [ProductOptionDto]
    let optionValueImages: [OptionValueImageDto]
}

extension ProductDetailDto {
    func toDomain() -> ProductDetail {
        let primaryImages = productImages.filter { $0.isPrimary }
        let nonPrimaryImages = productImages.filter { !$0.isPrimary }
        let productImages = (primaryImages + nonPrimaryImages).sorted { $0.position < $1.position }
        
        return ProductDetail(id: id,
                             name: name,
                             description: description,
                             defaultVariantId: defaultVariant.id,
                             productVariants: productVariants.map { $0.toDomain()},
                             productImageUrls: productImages.map {$0.url},
                             productOptions: productOptions.map { $0.toDomain() },
                             optionValueImages: optionValueImages.map { $0.toDomain() }
                             
        )
    }
}

