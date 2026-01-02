//
//  AuthRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import Foundation

protocol AuthRepository {
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() async throws
    
    var sessionInfoStream: AsyncStream<SessionInfo?> { get }
}
