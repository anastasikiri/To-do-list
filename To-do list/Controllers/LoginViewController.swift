//
//  ViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let authApiHelper = AuthApiHelper()
    
    private func validateEmail() -> String? {
        if loginTextField.text?.isEmpty == true || loginTextField.text?.isValidEmail == false {
            return "Please enter correct email"
        }
        return nil
    }
    
    private func validatePass() -> String? {
        if passwordTextField.text?.isEmpty == true {
            return "Please enter your password"
        }
        else if passwordTextField.text!.count < 8 {
            return "Password must have at least 8 characters"
        }
        return nil
    }    
    
    private func validateCredentials() -> Bool {
        let loginMessage = validateEmail()
        let passMessage = validatePass()
        
        if loginMessage != nil || passMessage != nil {
            var message = String()
            if let loginMessage = loginMessage {
                message = loginMessage
            } else if let passMessage = passMessage {
                message = passMessage
            }
            Alert.showBasic(title: message, vc: self)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        if validateCredentials() {
            guard let email = loginTextField.text,
                  let password = passwordTextField.text else {return}
            
            authApiHelper.executeLoginRequest(email: email, password: password) { result in
                var message = String()
                if let result = result {
                    if result.token != nil {
                        APIHelper.token = result.token!
                            let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
                        self.navigationController?.pushViewController(taskListVC,
                                                                           animated: true)
                    } else {
                        message = "User doesn't exist with provided email and passsword"
                    }
                } else {
                    message = "Something went wrong. Please try again."
                }
                if !message.isEmpty {
                    Alert.showBasic(title: message, vc: self)
                }
            }
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if validateCredentials() {
            guard let email = loginTextField.text,
                  let password = passwordTextField.text else {return}
            
            authApiHelper.executeRegisterRequest(email: email, password: password) { result in
                var message = String()
                if let result = result {
                    if result.status == "ok"{
                        message = "Registration successfull"
                    } else {
                        message = "This email alredy exist"
                    }
                } else {
                    message = "Something went wrong. Please try again."
                }
                Alert.showBasic(title: message, vc: self)
            }
        }
    }
}


