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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        if  loginTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter your login",
                vc: self)
        } else if passwordTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter your password",
                vc: self)
        } else {
            
            let taskListVC = self.storyboard?.instantiateViewController(
                withIdentifier: "TaskListViewController") as? TaskListViewController
            self.navigationController?.pushViewController(taskListVC!, animated: true)
            
            loginTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
  
    }
}

