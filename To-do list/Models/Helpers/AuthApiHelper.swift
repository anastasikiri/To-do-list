//
//  LoginApiHelper.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-10-29.
//

import Foundation

final class AuthApiHelper {
    
    private enum AuthMethod {
        case login
        case register
        var path: String {
            switch self {
            case .login: return "auth"
            case .register: return "register"
            }
        }
    }
    
    private let apiHelper = APIHelper()
    
    func executeLoginRequest (email: String,
                              password: String,
                              completion: @escaping (Result <LoginResponse, APIHelper.ErrorAPI>) -> Void) {
        apiHelper.createPostRequest(query: AuthMethod.login.path,
                                    params: ["email": email, "password": password],
                                    completion: completion)
    }
    
    func executeRegisterRequest (email: String,
                                 password: String,
                                 completion: @escaping (Result <NetworkResponse, APIHelper.ErrorAPI>) -> Void) {
        apiHelper.createPostRequest(query: AuthMethod.register.path,
                                    params: ["email": email, "password": password],
                                    completion: completion)
    }
}
