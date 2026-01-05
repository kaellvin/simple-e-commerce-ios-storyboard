//
//  ProductAPI.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 04/01/2026.
//

import Foundation

enum ProductAPI {
    case getProducts(keyword: String?)
    case getProduct(productId: String)
}

extension ProductAPI: Endpoint {
    
    var path: String {
        switch self {
        case .getProducts: "/api/public/v1/products"
        case .getProduct(let productId): "/api/public/v1/products/\(productId)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .getProducts(keyword):
            [
                URLQueryItem(name: "query", value: keyword)
            ]
        default:
            nil
        }
    }
    
    var body: Encodable? { nil }
    
}
