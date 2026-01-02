//
//  AccountViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation

@MainActor
class AccountViewModel {
    private let authRepository: AuthRepository
    
    @Published private(set) var isAuthenticated = false
    @Published private(set) var userEmail = ""
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        observeAuthState()
    }
    
    func observeAuthState() {
        Task {
            for await sessionInfo in authRepository.sessionInfoStream {
                self.isAuthenticated = sessionInfo != nil
                if let sessionInfo {
                    userEmail = sessionInfo.userEmail
                }else{
                    userEmail = ""
                }
            }
        }
    }
    
    func signOut() async {
        try? await authRepository.signOut()
    }
}
