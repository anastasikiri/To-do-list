//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: AnyObject {
    func taskDetails(_ controller: TaskDetailsViewController, didCreateUpdate task: Task)
}

class TaskDetailsViewController: UIViewController {
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var statusButtonOutlet: UIButton!
  
    enum ViewType {
        case createTask
        case updateTask
    }
    
    var task = Task()
    var viewType = ViewType.createTask
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewType == .updateTask {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            id = task.id
            StatusButton.updateStatus(statusButtonOutlet, task.status)
        }
    }
    
    @IBAction func changeStatusButton(_ sender: UIButton) {
        task.status = StatusButton.changeStatus(task.status)
        StatusButton.updateStatus(statusButtonOutlet, task.status)

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
                               status: task.status,
                               id: id)
            delegate?.taskDetails(TaskDetailsViewController(), didCreateUpdate: newTask)
            navigationController?.popViewController(animated: true)
        }
    }
}
