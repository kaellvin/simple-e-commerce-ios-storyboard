//
//  DefaultAuthRepository.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import Foundation
import Supabase

class DefaultAuthRepository : BaseRepository, AuthRepository {
    
    func signUp(email: String, password: String) async throws {
 
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await supabaseManager.auth.signIn(email: email, password: password)
        } catch let error as APIError {
            logError(error: error)
            throw RepositoryError.networkError
        } catch let error as Supabase.AuthError {
            throw RepositoryError.authError(error.localizedDescription)
        } catch {
            throw RepositoryError.unknownError
        }
    }
    
    func signOut() async throws {

    }
    
    lazy var sessionInfoStream = AsyncStream(SessionInfo?.self) { continuation in
        Task {
            for await (event, session) in supabaseManager.auth.authStateChanges {
                if let user = session?.user {
                    let sessionInfo = SessionInfo(userEmail: user.email ?? "")
                    continuation.yield(sessionInfo)
                }else{
                    continuation.yield(nil)
                }
            }
        }
        
    }
    
    
}
