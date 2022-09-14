//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: AnyObject {
    func sendTaskDetails(_: TaskDetailsViewController, didCreateUpdate task: Task)
}

class TaskDetailsViewController: UIViewController {
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    
    

    var task = Task()
    var counter = 0
    var status = Task.Status.todo
    var choosenTableViewCell = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if choosenTableViewCell {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            status = task.status!
            
            switch status {
            case .inProgress:
                statusButtonOutlet.backgroundColor = .systemOrange
                statusButtonOutlet.setTitle(status.rawValue, for: .normal)
            case .done:
                statusButtonOutlet.backgroundColor = .systemRed
                statusButtonOutlet.setTitle(status.rawValue, for: .normal)
            case .todo:
                statusButtonOutlet.backgroundColor = .systemGreen
                statusButtonOutlet.setTitle(status.rawValue, for: .normal)
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
                status = .inProgress
                sender.backgroundColor = .systemOrange
                sender.setTitle(status.rawValue, for: .normal)
            case 2:
                status = .done
                sender.backgroundColor = .systemRed
                sender.setTitle(status.rawValue, for: .normal)
            case 3:
                status = .todo
                sender.backgroundColor = .systemGreen
                sender.setTitle(status.rawValue, for: .normal)
                counter = 0
            default:
                break
            }
        } else {
            switch status {
            case .inProgress:
                status = .done
                sender.backgroundColor = .systemRed
                sender.setTitle(status.rawValue, for: .normal)
            case .done:
                status = .todo
                sender.backgroundColor = .systemGreen
                sender.setTitle(status.rawValue, for: .normal)
            case .todo:
                status = .inProgress
                sender.backgroundColor = .systemOrange
                sender.setTitle(status.rawValue, for: .normal)
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
            let newTask = Task(title: titleTextField.text!,
                               description: descriptionTextField.text!,
                               deadline: Date(),
                               status: status)
            delegate?.sendTaskDetails(TaskDetailsViewController(), didCreateUpdate: newTask)
            navigationController?.popViewController(animated: true)
        }
    }
}
