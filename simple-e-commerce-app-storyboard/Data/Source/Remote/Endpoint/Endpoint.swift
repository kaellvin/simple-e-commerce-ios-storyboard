//
//  Endpoint.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    var queryItems: [URLQueryItem]? {get}
    
    var body: Encodable? { get }
    
    func urlRequest() -> URLRequest?
    
}

extension Endpoint {
    //TODO: relocate
    var baseURL: URL { URL(string: "http://localhost:3001")! }
    
    func urlRequest() -> URLRequest? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path = path
        
        if let queryItems, !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
  
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
