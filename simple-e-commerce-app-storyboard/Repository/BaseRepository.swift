//
//  BaseRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

class BaseRepository {
    
    private let networkManager: NetworkManager
    let supabaseManager: SupabaseManager
    
    init(networkManager: NetworkManager = NetworkManager(),
         supabaseManager: SupabaseManager = .shared,
    ) {
        self.networkManager = networkManager
        self.supabaseManager = supabaseManager
    }
    
    
    func request(endpoint: Endpoint) async throws ->Data {
      return try await networkManager.request(endpoint: endpoint)
    }
    
    func decode<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError(type: .invalidData)
        }
    }
    
    func logError(error: APIError){
        let fn = #function
        switch error.type {
        case .internalError(let code, let msg):
            print("❌[\(repositoryName).\(fn)]\nError: \(error.type.name)\nMessage: \(msg)\nStatus: \(code)")
        default:
            print("❌[\(repositoryName).\(fn)]\nError: \(error.type.name)")
        }
    }
    
    var repositoryName: String {
        String(describing: type(of: self))
    }
}


