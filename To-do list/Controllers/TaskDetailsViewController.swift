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
    private var message = String()
    private var viewModel: TaskDetailsModelProtocol = TaskDetailsModel(client: TaskApiHelper())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIElements()
        configureUIDatePicker()
        
        viewModel.observableState = { [weak self] state in
            switch state {
            case .taskChanged(let receivedMessage):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.showAlertWithTimer(title: receivedMessage, vc: self!)
                }
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.message = self?.parse(error) ?? ""
            case .validateDataInput(let receivedMessage):
                self?.message = receivedMessage
            }
            if self?.message != "" {
                self?.showBasicAlert(title: self!.message, vc: self!)
            }
        }
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = String(datePicker.date.formatDate())
    }
    
    private func prepareUIElements() {
        titleTextField.text = task.title
        contentTextField.text = task.content
        dateTextField.text = task.deadline.convertToDateFormat(current: Constants.DateFormat.dateWithSec,
                                                               convertTo: Constants.DateFormat.dateWithoutSec)
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
        
    @IBAction func changeStatusButton(_ sender: UIButton) {
        task.status = task.status.nextState
        updateStatusUI(statusButton, task.status)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        viewModel.submit(title: titleTextField.text,
                         content: contentTextField.text,
                         deadline: dateTextField.text,
                         status: statusButton.titleLabel?.text,
                         task: task)
    }
}
