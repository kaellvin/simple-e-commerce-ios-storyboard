//
//  APIResponse.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 04/01/2026.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
}
