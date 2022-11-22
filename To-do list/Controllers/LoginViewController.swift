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
    var message = String()
    
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
            showBasicAlert(title: message, vc: self)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard
            validateCredentials(),
            let email = loginTextField.text,
            let password = passwordTextField.text
        else { return }
        
        authApiHelper.executeLoginRequest(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            var message = String()
            
            switch result {
            case .success(let result):
                if let token = result.token {
                    APIHelper.token = token
                    let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
                    self.navigationController?.pushViewController(taskListVC, animated: true)
                } else {
                    message = "Something went wrong"
                }
            case .failure(let error):
                message = self.parse(error)
            }
            
            if !message.isEmpty {
                self.showBasicAlert(title: message, vc: self)
            }
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard
            validateCredentials(),
            let email = loginTextField.text,
            let password = passwordTextField.text
        else { return }
        
        authApiHelper.executeRegisterRequest(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            var message = String()
            switch result {
            case .success:
                message = "Registration successfull"
            case .failure(let error):
                message = self.parse(error) 
            }
            self.showBasicAlert(title: message, vc: self)
        }
    }
}


