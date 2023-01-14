//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-08.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var dateTextField: UITextField!
    
    private var viewModel: TaskDetailsViewModelProtocol = TaskDetailsViewModel(api: TaskAPIHelper())

    var task = Task()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIElements()
        configureUIDatePicker()
        subscribeForDataUpdates()
    }

    // MARK: Preparations
    private func subscribeForDataUpdates() {
        viewModel.observableState = { [weak self] state in
            guard let self = self else { return }
            var message = String()

            switch state {
            case .taskChanged(let receivedMessage):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showAlertWithTimer(title: receivedMessage, vc: self)
                }
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                message = self.parse(error)
            case .validateDataInput(let receivedMessage):
                message = receivedMessage
            }

            if message != "" {
                self.showBasicAlert(title: message, vc: self)
            }
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

    private func prepareUIElements() {
        titleTextField.text = task.title
        contentTextField.text = task.content
        dateTextField.text = task.deadline.convertToDateFormat(current: Constants.DateFormat.dateWithSec,
                                                               convertTo: Constants.DateFormat.dateWithoutSec)
        updateStatusUI(statusButton, task.status)
    }

    // MARK: Date picker delegate
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = String(datePicker.date.formatDate())
    }
    

    // MARK: Private funcs
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
    

    @IBAction private func changeStatusButton(_ sender: UIButton) {
        task.status = task.status.nextState
        updateStatusUI(statusButton, task.status)
    }
    
    @IBAction private func submitButton(_ sender: UIButton) {
        guard viewModel.validateDataInput(title: titleTextField.text, content: contentTextField.text),
              let title = titleTextField.text,
              let content = contentTextField.text,
              let deadline = dateTextField.text,
              let status = statusButton.titleLabel?.text
        else { return }

        viewModel.submit(title: title,
                         content: content,
                         deadline: deadline,
                         status: status,
                         task: task)
    }
}
