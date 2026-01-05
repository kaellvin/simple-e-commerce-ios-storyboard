//
//  HomeViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 01/01/2026.
//

import Foundation

@MainActor
class HomeViewModel {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    @Published private(set) var products: [Product] = []
    var filteredProducts: [Product]?
    var search: String = ""
    var status = LoadingStatus.idle
    var event: HomeEvent?
    
    
    func loadData(isRefresh: Bool = false) async {
        status = LoadingStatus.loading
        do {
            products = try await productRepository.getProducts(keyword: nil)
            status = LoadingStatus.success
            
            if(isRefresh){
                event = .homeRefreshSuccess
            }
        } catch {
            status = LoadingStatus.failure(error.localizedDescription)
            
            if(isRefresh){
                event = .homeRefreshFailed
            }else{
                event = .homeLoadFailed
            }
        }
        
    }
    
    func refreshData() async{
        await loadData(isRefresh: true)
    }
    
    func searchProduct(keyword: String) async {
        do {
            filteredProducts = try await productRepository.getProducts(keyword: keyword)
            status = LoadingStatus.success
            
        } catch {
            status = LoadingStatus.failure(error.localizedDescription)
        }
    }
    
    func clearSearch() {
        filteredProducts = nil
    }
    
    enum HomeEvent: Equatable {
        case homeLoadFailed
        case homeRefreshSuccess
        case homeRefreshFailed
    }
}
//TODO:relocate
enum LoadingStatus: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}
