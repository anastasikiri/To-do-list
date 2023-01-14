//
//  TaskDetailsViewModel.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-12-03.
//

import Foundation

enum TaskDetailsViewModelState {
    case taskChanged(String)
    case failure(APIHelper.ErrorAPI)
    case validateDataInput(String)
}


protocol TaskDetailsViewModelProtocol {
    var observableState: ((TaskDetailsViewModelState) -> Void)? { get set }

    func validateDataInput(title: String?, content: String?) -> Bool
    func submit(title: String,
                content: String,
                deadline: String,
                status: String,
                task: Task)
}

class TaskDetailsViewModel: TaskDetailsViewModelProtocol {
    
    var observableState: ((TaskDetailsViewModelState) -> Void)?
    private let api: TaskAPIHelperProtocol
    
    init(api: TaskAPIHelperProtocol) {
        self.api = api
    }

    // MARK: - Private funcs
    private func proceedResult(result: Result <TaskResponse, APIHelper.ErrorAPI>,
                               message: String) {
        switch result {
        case .success(_):
            self.observableState?(.taskChanged(message))
        case .failure(let error):
            self.observableState?(.failure(error))
        }
    }

    // MARK: Public funcs
    func validateDataInput(title: String?, content: String?) -> Bool {
        if  title?.isEmpty == true {
            self.observableState?(.validateDataInput("Please enter title of task"))
            return false
        } else if content?.isEmpty == true {
            self.observableState?(.validateDataInput("Please enter description of task"))
            return false
        } else {
            return true
        }
    }

    func submit(title: String, content: String, deadline: String, status: String, task: Task) {
        if task.id == 0 {
            api.createTask(title: title,
                           content: content,
                           deadline: deadline,
                           status: status) { [weak self] result in
                guard let self = self else { return }
                self.proceedResult(result: result, message: "Task added successfully")
            }
        } else {
            api.editTask(id: "\(task.id)",
                         title: title,
                         content: content,
                         deadline: deadline,
                         status: status) { [weak self] result in
                guard let self = self else { return }
                self.proceedResult(result: result, message: "Task edited successfully")
            }
        }
    }
}
