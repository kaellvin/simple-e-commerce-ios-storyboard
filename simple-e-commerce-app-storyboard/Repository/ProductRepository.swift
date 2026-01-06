//
//  ProductRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 04/01/2026.
//

import Foundation

protocol ProductRepository {
    
    func getProducts(keyword: String?) async throws -> [Product]
    func getProduct(productId: String) async throws -> ProductDetail?
}
