//
//  LoginApiHelper.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-10-29.
//

import Foundation

protocol AuthAPIHelperProtocol {
    func executeLoginRequest (email: String,
                              password: String,
                              completion: @escaping (Result <LoginResponse, APIHelper.ErrorAPI>) -> Void)

    func executeRegisterRequest (email: String,
                                 password: String,
                                 completion: @escaping (Result <NetworkResponse, APIHelper.ErrorAPI>) -> Void)
}

class AuthAPIHelper: APIHelper, AuthAPIHelperProtocol {
    
    private enum AuthMethod: String {
        case auth, register
    }

    func executeLoginRequest (email: String,
                              password: String,
                              completion: @escaping (Result <LoginResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: AuthMethod.auth.rawValue,
                               params: ["email": email, "password": password],
                               completion: completion)
    }
    
    func executeRegisterRequest (email: String,
                                 password: String,
                                 completion: @escaping (Result <NetworkResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: AuthMethod.register.rawValue,
                               params: ["email": email, "password": password],
                               completion: completion)
    }
}
