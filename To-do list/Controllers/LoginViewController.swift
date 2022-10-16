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
        return nil
    }
    
    @IBAction func signInButton(_ sender: UIButton) {        
        let loginMessage = validateEmail()
        let passMessage = validatePass()
        
        if loginMessage == nil && passMessage == nil {
            let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
            self.navigationController?.pushViewController(taskListVC, animated: true)
        } else {
            var message = String()
            if let loginMessage = loginMessage {
                message = loginMessage
            } else if let passMessage = passMessage {
                message = passMessage
            }
            Alert.showBasic(title: message, vc: self)
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
    }
}

