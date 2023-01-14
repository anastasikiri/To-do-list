//
//  ViewController.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-08.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: LoginViewModelProtocol = LoginViewModel(api: AuthAPIHelper())

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForDataUpdates()
    }

    // MARK: - Preparations
    private func subscribeForDataUpdates() {
        viewModel.observableState = { [weak self] state in
            guard let self = self else { return }

            var message = String()

            switch state {
            case .loaded:
                let taskListVC = TaskListViewController.loadFromStoryboard(type: TaskListViewController.self)
                self.navigationController?.pushViewController(taskListVC, animated: true)
            case .loadedError(let receivedMessage):
                message = receivedMessage
            case .failure(let error):
                message = self.parse(error)
            case .registered(let receivedMessage):
                message = receivedMessage
            case .validateEmail(let receivedMessage):
                message = receivedMessage
            case .validatePassword(let receivedMessage):
                message = receivedMessage
            }

            if message != "" {
                self.showBasicAlert(title: message, vc: self)
            }
        }
    }

    // MARK: - private funcs
    @IBAction private func signInButton(_ sender: UIButton) {
        guard let login = loginTextField?.text, let password = passwordTextField?.text else { return }
        viewModel.signIn(login: login, password: password)
        
    }
    
    @IBAction private func registerButton(_ sender: UIButton) {
        guard let login = loginTextField?.text, let password = passwordTextField?.text else { return }
        viewModel.register(login: login, password: password)
    }
}
