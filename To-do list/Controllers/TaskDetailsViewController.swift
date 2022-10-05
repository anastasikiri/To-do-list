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
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var dateTextField: UITextField!
    
    var task = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIElements()
        configureUIDatePicker()
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = datePicker.date.formatDate()
    }
    
    private func prepareUIElements() {
        titleTextField.text = task.title
        descriptionTextField.text = task.description
        dateTextField.text = task.deadline.formatDate()
        updateStatusUI(statusButton, task.status)
    }
    
    private func updateStatusUI(_ sender: UIButton, _ status: Task.Status) {
        sender.setTitle(status.rawValue, for: .normal)
        
        switch status {
        case .inProgress:
            sender.backgroundColor = .systemOrange
        case .done:
            sender.backgroundColor = .systemRed
        case .todo:
            sender.backgroundColor = .systemGreen
        }
    }
    
    private func configureUIDatePicker() {
        let width = 0
        let height = 200
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self,
                             action: #selector(dateChange(datePicker:)),
                             for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: width, height: height)
        dateTextField.inputView = datePicker
        datePicker.date = task.deadline
    }
    
    @IBAction func changeStatusButton(_ sender: UIButton) {
        task.status = task.status.nextState
        updateStatusUI(statusButton, task.status)
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
            let newTask = Task(title: titleTextField.text ?? "",
                               description: descriptionTextField.text ?? "",
                               deadline: dateTextField.text?.getDate() ?? Date(),
                               status: task.status,
                               id: task.id)
            delegate?.taskDetails(TaskDetailsViewController(), didCreateUpdate: newTask)
            navigationController?.popViewController(animated: true)
        }
    }
}
