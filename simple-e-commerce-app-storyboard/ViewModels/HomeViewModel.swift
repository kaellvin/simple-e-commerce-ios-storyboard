//
//  HomeViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 01/01/2026.
//

import Foundation

//TODO:relocate
enum LoadingStatus: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}
