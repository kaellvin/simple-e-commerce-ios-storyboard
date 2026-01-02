//
//  NetworkManager.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

class NetworkManager {
    
    private let supabaseManager: SupabaseManager
    
    init(supabaseManager: SupabaseManager = .shared) {
        self.supabaseManager = supabaseManager
    }

    func request(endpoint: Endpoint) async throws -> Data {
        
        guard var request = endpoint.urlRequest() else { throw APIError(type: .invalidURL) }
        
        //TODO: integrate with REST API
        if let session = try? await supabaseManager.auth.session  {
            request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(type: .invalidResponse)
            //throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown Error."
            throw APIError(type: .internalError(statusCode: httpResponse.statusCode, message: message))
        }
        
        return data
        
        
    }
}


