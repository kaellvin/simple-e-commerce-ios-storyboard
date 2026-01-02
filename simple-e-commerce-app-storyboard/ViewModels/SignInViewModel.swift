//
//  SignInViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import Foundation

@MainActor
class SignInViewModel {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    @Published var email: String = ""
    @Published private(set) var emailError: FormValidationError?
    @Published var password: String = ""
    @Published private(set) var passwordError: FormValidationError?
    @Published private(set) var status = LoadingStatus.idle
    
    func validateEmail() {
        guard !email.isEmpty else {
            emailError = FormValidationError.emailEmpty
            return
        }
    
        guard email.isValidEmail else {
            emailError = FormValidationError.invalidEmail
            return
        }
        emailError = nil
    }
    
    func validatePassword() {
        guard !password.isEmpty else {
            passwordError = FormValidationError.passwordEmpty
            return
        }
        passwordError = nil
    }
    
    func validateBeforeSignIn() async {
        validateEmail()
        validatePassword()
        
        if emailError == nil && passwordError == nil {
            await signIn()
        }
    }
    
    func signIn() async {
        status = LoadingStatus.loading
        do {
            try await authRepository.signIn(email: email, password: password)
            status = LoadingStatus.success
        } catch {
            status = LoadingStatus.failure(error.localizedDescription)
        }
    }
    
}
//TODO:relocate
enum FormValidationError {
    case emailEmpty
    case invalidEmail
    case passwordEmpty
    
    var name: String {
        switch self {
        case .emailEmpty:
            "Email is required."
        case .invalidEmail:
            "Invalid email."
        case .passwordEmpty:
            "Password is required."
        }
    }
}

