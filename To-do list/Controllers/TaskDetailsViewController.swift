//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var dateTextField: UITextField!
    
    var task = Task()
    private let taskApiHelper = TaskApiHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIElements()
        configureUIDatePicker()        
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = String(datePicker.date.formatDate())
    }
    
    private func prepareUIElements() {
        titleTextField.text = task.title
        contentTextField.text = task.content
        dateTextField.text = task.deadline.convertToDateFormat(current: "yyyy-MM-dd HH:mm:ss",
                                                               convertTo: "yyyy-MM-dd HH:mm")
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
        let height = 430
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self,
                             action: #selector(dateChange(datePicker:)),
                             for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: width, height: height)
        dateTextField.inputView = datePicker
        datePicker.date = task.deadline.getDate() ?? .now
    }
    
    private func validateDataInput() -> Bool {
        if  titleTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter title of task",
                vc: self)
            return false
        } else if contentTextField.text?.isEmpty == true {
            Alert.showBasic(
                title: "Please enter description of task",
                vc: self)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func changeStatusButton(_ sender: UIButton) {
        task.status = task.status.nextState
        updateStatusUI(statusButton, task.status)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        if validateDataInput() {
            guard let title = titleTextField.text ,
            let content = contentTextField.text ,
            let deadline = dateTextField.text ,
            let status = statusButton.titleLabel?.text else {return}
            
            if task.id == 0 {
                taskApiHelper.addTask(title: title,
                                      content: content,
                                      deadline: deadline,
                                      status: status) { result in
                    var message = String()
                    if let result = result {
                        if result.status == "ok"  {
                            message = "Task added successfully"
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            message = "Session expired"
                        }
                    } else {
                        message = "Something went wrong. Please try again."
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        Alert.showBasicWithTimer(title: message, vc: self)
                    }
                }
            } else {
                
                taskApiHelper.editTask(id: "\(task.id)",
                                         title: title,
                                         content: content,
                                         deadline: deadline,
                                         status: status) { result
                    
                    in
                    var message = String()
                    if let result = result {
                        if result.status == "ok" {
                            message = "Task edited successfully"
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            message = "Session expired"
                        }
                    } else {
                        message = "Something went wrong. Please try again."
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        Alert.showBasicWithTimer(title: message, vc: self)
                    }
                }
            }
        }
    }
}
