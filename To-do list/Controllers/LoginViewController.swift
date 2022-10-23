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
            let email = loginTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let query = "auth"
            
            APICaller.shared.executePostRequest(with: query,
                                                params: ["email" : email,
                                                         "password": password],
                                                completion: { result, error  in
                var message = String()
                
                if error != nil {
                    message = "Something went wrong. Please try again."
                } else {
                    if result?["token"] != nil {
                        APICaller.token = result?["token"] as! String
                        DispatchQueue.main.async {
                            let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
                            self.navigationController?.pushViewController(taskListVC, animated: true)
                        }
                    } else {
                        message = "User doesn't exist with provided email and passsword"
                    }
                }
                if !message.isEmpty {
                    DispatchQueue.main.async {
                        Alert.showBasic(title: message, vc: self)
                    }
                }
            })
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if validateCredentials() {
            let email = loginTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let query = "register"
            
            APICaller.shared.executePostRequest(with: query,
                                                params: ["email" : email,
                                                         "password": password],
                                                completion: { result, error  in
                var message = String()
                
                if error != nil {
                    message = "Something went wrong. Please try again."
                } else {
                    if let status = result?["status"], status as! String == "ok" {
                        message = "Registration successfull"
                    } else {
                        message = "This email alredy exist"
                    }
                }
                DispatchQueue.main.async {
                    Alert.showBasic(title: message, vc: self)
                }
            })
        }
    }
}


