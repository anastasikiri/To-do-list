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
    
    private var message = String()
    private var viewModel: LoginModelProtocol = LoginModel(client: AuthApiHelper())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.observableState = { [weak self] state in
            switch state {
            case .loaded:
                self?.message = String()
                let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
                self?.navigationController?.pushViewController(taskListVC, animated: true)
            case .loadedError(let receivedMessage):
                self?.message = receivedMessage
            case .failure(let error):
                self?.message = self?.parse(error) ?? ""
            case .registered(let receivedMessage):
                self?.message = receivedMessage
            case .validateEmail(let receivedMessage):
                self?.message = receivedMessage
            case .validatePassword(let receivedMessage):
                self?.message = receivedMessage
            }
            if self?.message != "" {
                self?.showBasicAlert(title: self!.message, vc: self!)
            }
        }
    }
    
    @IBAction private func signInButton(_ sender: UIButton) {
        viewModel.signIn(login: loginTextField.text, password: passwordTextField.text)
        
    }
    
    @IBAction private func registerButton(_ sender: UIButton) {
        viewModel.register(login: loginTextField.text, password: passwordTextField.text)
    }    
}
