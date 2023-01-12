//
//  LoginViewModel.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-11-29.
//

import Foundation

enum LoginModelState {
    case loaded
    case registered(String)
    case loadedError(String)
    case failure(APIHelper.ErrorAPI)
    case validateEmail(String)
    case validatePassword(String)
}


protocol LoginModelProtocol {
    func signIn(login: String?, password: String?)
    func register(login: String?, password: String?)
    
    var observableState: ((LoginModelState) -> Void)? { get set }
}


class LoginModel: LoginModelProtocol {
  
    var observableState: ((LoginModelState) -> Void)?
    private let authApiHelper: AuthApiHelper
    
    init(client: AuthApiHelper) {
        self.authApiHelper = client
    }
    
    private func validateEmail(login: String?) -> String? {
        if login?.isEmpty == true || login?.isValidEmail == false {
            return "Please enter correct email"
        }
        return nil
    }
    
    private func validatePass(password: String?) -> String? {
        if password?.isEmpty == true {
            return "Please enter your password"
        }
        else if password!.count < 8 {
            return "Password must have at least 8 characters"
        }
        return nil
    }
    
    private func validateCredentials(login: String?, password: String?) -> Bool {
        let loginMessage = validateEmail(login: login)
        let passMessage = validatePass(password: password)
        
        if loginMessage != nil || passMessage != nil {
            if let loginMessage = loginMessage {
                self.observableState?(.validateEmail(loginMessage))
            } else if let passMessage = passMessage {
                self.observableState?(.validatePassword(passMessage))
            }
            return false
        } else {
            return true
        }
    }
        
    func signIn(login: String?, password: String?) {
        guard
            validateCredentials(login: login, password: password),
            let email = login,
            let password = password
        else { return }
        
        authApiHelper.executeLoginRequest(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            var message = String()
            
            switch result {
            case .success(let result):
                if let token = result.token {
                    APIHelper.token = token
                    self.observableState?(.loaded)
                } else {
                    message = "Something went wrong"
                    self.observableState?(.loadedError(message))
                }
            case .failure(let error):
                self.observableState?(.failure(error))
            }
        }
    }
    
    func register(login: String?, password: String?) {
        guard
            validateCredentials(login: login, password: password),
            let email = login,
            let password = password
        else { return }
        
        authApiHelper.executeRegisterRequest(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            var message = String()
            switch result {
            case .success:
                message = "Registration successfull"
                self.observableState?(.registered(message))
            case .failure(let error):
                self.observableState?(.failure(error))
            }
        }
    }
}

