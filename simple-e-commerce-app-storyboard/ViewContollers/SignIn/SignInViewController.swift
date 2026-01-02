//
//  SignInViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    private var viewModel = SignInViewModel(authRepository: DefaultAuthRepository())
    private var cancellables = Set<AnyCancellable>()
    
    private var isDismissing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        emailTextField.setLeadingIcon(systemName: "envelope")
        emailTextField.delegate = self
        
        passwordTextField.setLeadingIcon(systemName: "lock")
        passwordTextField.setTrailingPasswordIcon()
        passwordTextField.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isDismissing = true
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        Task {
            await viewModel.validateBeforeSignIn()
        }
    }
    
    private func bind() {
        //NOTE: update view model
        NotificationCenter
            .default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField )
            .compactMap {$0.object as? UITextField}
            .map { $0.text ?? "" }
            .assign(to: &viewModel.$email)
        
        NotificationCenter
            .default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField )
            .compactMap {$0.object as? UITextField}
            .map { $0.text ?? "" }
            .sink { [weak self] password in
                guard let self else { return}
                self.viewModel.password = password
                self.viewModel.validatePassword()
            }
            .store(in: &cancellables)
        
        viewModel
            .$emailError
            .map { $0?.name ?? ""}
            .assign(to: \.text, on: emailErrorLabel)
            .store(in: &cancellables)
        
        viewModel
            .$passwordError
            .map { $0?.name ?? ""}
            .assign(to: \.text, on: passwordErrorLabel)
            .store(in: &cancellables)
        
//        viewModel
//            .$passwordError
//            .sink { passwordError in
//                self.passwordErrorLabel.text = passwordError?.name ?? ""
//            }
//            .store(in: &cancellables)
        
        
    }
    
    deinit {
        print("SHOULD EXIT")
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard !isDismissing else { return }
        
        if textField == emailTextField {
            viewModel.validateEmail()
        }
        
        
    }
    
}
