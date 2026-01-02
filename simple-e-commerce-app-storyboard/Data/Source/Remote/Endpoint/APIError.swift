//
//  APIError.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

struct APIError: Error {
    enum ErrorType {
        case invalidURL
        case invalidResponse
        case internalError(statusCode: Int, message: String)
        case invalidData
        //TODO:
        case encodingFailed
        
        var name: String {
            switch self {
            case .invalidURL:
                "invalidURL"
            case .invalidResponse:
                "invalidResponse"
            case .internalError:
                "internalError"
            case .invalidData:
                "invalidData"
            case .encodingFailed:
                "encodingFailed"
            }
        }
    }
    let type: ErrorType
}

//NOTE
//enum APIError: Error {
//    case invalidResponse
//    case internalError(statusCode: Int, message: String)
//    case invalidData
//}
