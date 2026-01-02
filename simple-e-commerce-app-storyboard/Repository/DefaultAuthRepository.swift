//
//  DefaultAuthRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import Foundation

class DefaultAuthRepository : AuthRepository {
    
    func signUp(email: String, password: String) async throws {
 
    }
    
    func signIn(email: String, password: String) async throws {
 print("TEST TRY SIGN IN")
    }
    
    func signOut() async throws {

    }
    
    lazy var sessionInfoStream = AsyncStream(SessionInfo?.self) { continuation in
        Task {
//            for await (event, session) in supabaseManager.auth.authStateChanges {
//                if let user = session?.user {
//                    let sessionInfo = SessionInfo(userEmail: user.email ?? "")
//                    continuation.yield(sessionInfo)
//                }else{
//                    continuation.yield(nil)
//                }
//            }
        }
        
    }
    
    
}
