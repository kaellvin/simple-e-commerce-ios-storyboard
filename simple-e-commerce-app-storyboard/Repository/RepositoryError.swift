//
//  RepositoryError.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

enum RepositoryError: Error, LocalizedError {
    case networkError
    case authError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network Failed. Please try again later."
        case .authError(let message):
            return message
        case .unknownError:
            return "Unknown Error."
        }
        
    }
}
