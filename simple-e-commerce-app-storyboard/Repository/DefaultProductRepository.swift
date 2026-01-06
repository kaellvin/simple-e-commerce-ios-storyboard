//
//  DefaultProductRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 04/01/2026.
//

import Foundation

class DefaultProductRepository: BaseRepository, ProductRepository {

    func getProducts(keyword: String?) async throws -> [Product] {
        do {
            let data = try await request(endpoint: ProductAPI.getProducts(keyword: keyword))
            let response = try decode(APIResponse<[ProductDto]>.self, data: data)
            return response.data.map { $0.toDomain() }
            
        } catch let error as APIError {
            logError(error: error)
            throw RepositoryError.networkError
        } catch  {
            throw RepositoryError.unknownError
        }

    }
    
    func getProduct(productId: String) async throws -> ProductDetail? {
        do {
            let data = try await request(endpoint: ProductAPI.getProduct(productId: productId))
            let response = try decode(APIResponse<ProductDetailDto?>.self, data: data)
            return response.data?.toDomain()
            
        } catch let error as APIError {
            logError(error: error)
            throw RepositoryError.networkError
        } catch  {
            throw RepositoryError.unknownError
        }
    }
    
}
