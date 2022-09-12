//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    
    var users = [User]()
    var userIndex = Int()
    var taskIndex = Int()
    var counter = 0
    var status = "to do"
    var titleField = ""
    var choosenTableViewCell = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = UserDefaultsManager.shared.getValueForUser() ?? [User]()
                titleTextField.text = titleField
        if choosenTableViewCell {
            titleTextField.text = users[userIndex].task?[taskIndex].title
            descriptionTextField.text = users[userIndex].task?[taskIndex].description
            
            switch users[userIndex].task?[taskIndex].status {
            case "in progress":
                statusButtonOutlet.backgroundColor = .systemOrange
                statusButtonOutlet.setTitle("in progress", for: .normal)
            case "done":
                statusButtonOutlet.backgroundColor = .systemRed
                statusButtonOutlet.setTitle("done", for: .normal)
            case "to do":
                statusButtonOutlet.backgroundColor = .systemGreen
                statusButtonOutlet.setTitle("to do", for: .normal)
            default:
                break
            }
        }
    }
    
    @IBAction func statusButton(_ sender: UIButton) {
        if choosenTableViewCell == false {
            counter += 1
            switch counter {
            case 1:
                sender.backgroundColor = .systemOrange
                sender.setTitle("in progress", for: .normal)
                status = sender.currentTitle ?? ""
            case 2:
                sender.backgroundColor = .systemRed
                sender.setTitle("done", for: .normal)
                status = sender.currentTitle ?? ""
            case 3:
                sender.backgroundColor = .systemGreen
                sender.setTitle("to do", for: .normal)
                status = sender.currentTitle ?? ""
                counter = 0
            default:
                break
            }
        } else {
            var currentStatus = users[userIndex].task?[taskIndex].status
            
            switch currentStatus {
            case "in progress":
                currentStatus = "done"
                sender.backgroundColor = .systemRed
                sender.setTitle("done", for: .normal)
                users[userIndex].task?[taskIndex].status = currentStatus!
                UserDefaultsManager.shared.setValueForUser(value: users)
            case "done":
                currentStatus = "to do"
                sender.backgroundColor = .systemGreen
                sender.setTitle("to do", for: .normal)
                users[userIndex].task?[taskIndex].status = currentStatus!
                UserDefaultsManager.shared.setValueForUser(value: users)
            case "to do":
                currentStatus = "in progress"
                sender.backgroundColor = .systemOrange
                sender.setTitle("in progress", for: .normal)
                users[userIndex].task?[taskIndex].status = currentStatus!
                UserDefaultsManager.shared.setValueForUser(value: users)
            default:
                break
            }
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        if  titleTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter title of task",
                vc: self)
        } else if descriptionTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter description of task",
                vc: self)
        } else {
            if choosenTableViewCell == false {
                
                let newTask = Task(title: titleTextField.text!,
                                   description: descriptionTextField.text!,
                                   deadline: "some date",
                                   status: status)
                print(newTask)
                if users[userIndex].task == nil {
                    users[userIndex] = User(login: users[userIndex].login,
                                            password: users[userIndex].password,
                                            task: [newTask])
                } else {
                    users[userIndex].task?.append(newTask)
                }
                print(users[userIndex].task as Any)
                UserDefaultsManager.shared.setValueForUser(value: users)
                navigationController?.popViewController(animated: true)
                
            } else {
                users[userIndex].task?[taskIndex].title = titleTextField.text!
                users[userIndex].task?[taskIndex].description = descriptionTextField.text!
                UserDefaultsManager.shared.setValueForUser(value: users)
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
