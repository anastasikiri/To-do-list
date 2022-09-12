//
//  ViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class LoginViewController: UIViewController {
    
    var users = [User]()
    var userIndex = Int()
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = UserDefaultsManager.shared.getValueForUser() ?? [User]()
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
        } else if users.isEmpty  {
            Alert.showBasic(
                title: "Invalid login, please register",
                vc: self)
        } else {
            for i in users.indices {
                if users[i].login == loginTextField.text, users[i].password == passwordTextField.text {
                    userIndex = i
                    let taskListVC = self.storyboard?.instantiateViewController(
                        withIdentifier: "TaskListViewController") as? TaskListViewController
                    taskListVC?.userIndex = userIndex
                    self.navigationController?.pushViewController(taskListVC!, animated: true)
                    
                    loginTextField.text = ""
                    passwordTextField.text = ""
                    break
                    
                } else if users[i].login == loginTextField.text, users[i].password != passwordTextField.text {
                    Alert.showBasic(
                        title: "Invalid password",
                        vc: self)
                } else if users[i].login != loginTextField.text, i == users.count-1 {
                    Alert.showBasic(
                        title: "Invalid login, please register or correct login",
                        vc: self)
                }
            }
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if  loginTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter your login",
                vc: self)
        } else if passwordTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter your password",
                vc: self)
        } else if users.isEmpty == true {
            users.append(User(login: loginTextField.text ?? "",
                              password: passwordTextField.text ?? ""))
            UserDefaultsManager.shared.setValueForUser(value: users)
            loginTextField.text = ""
            passwordTextField.text = ""
            
            Alert.showBasic(
                title: "Successfully registered, please Sign in",
                vc: self)
        } else {
            users = UserDefaultsManager.shared.getValueForUser() ?? [User]()
            
            if users.contains(where: {$0.login == loginTextField.text}) {
                Alert.showBasic(
                    title: "User already exist, please Sign in",
                    vc: self)
                loginTextField.text = ""
                passwordTextField.text = ""
            } else {
                users.append(User(login: loginTextField.text ?? "",
                                  password: passwordTextField.text ?? ""))
                UserDefaultsManager.shared.setValueForUser(value: users)
                loginTextField.text = ""
                passwordTextField.text = ""
                
                Alert.showBasic(
                    title: "Successfully registered, please Sign in",
                    vc: self)
            }
        }
    }
}

