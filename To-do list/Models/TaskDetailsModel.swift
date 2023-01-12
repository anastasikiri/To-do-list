//
//  TaskDetailsViewModel.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-12-03.
//

import Foundation

enum TaskDetailsModelState {
    case taskChanged(String)
    case failure(APIHelper.ErrorAPI)
    case validateDataInput(String)
}


protocol TaskDetailsModelProtocol {
    func submit(title: String?, content: String?, deadline: String?, status: String?, task: Task)
    
    var observableState: ((TaskDetailsModelState) -> Void)? { get set }
}

class TaskDetailsModel: TaskDetailsModelProtocol {
    
    var observableState: ((TaskDetailsModelState) -> Void)?
    private let taskApiHelper: TaskApiHelper
    
    init(client: TaskApiHelper) {
        self.taskApiHelper = client
    }
    
    private func proceedResult(result: Result <TaskResponse, APIHelper.ErrorAPI> ,
                               message: String) {
        switch result {
        case .success(_):
            self.observableState?(.taskChanged(message))
        case .failure(let error):
            self.observableState?(.failure(error))
        }
    }
    
    private func validateDataInput(title: String?, content: String?) -> Bool {
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
    
    func submit(title: String?, content: String?, deadline: String?, status: String?, task: Task) {
        guard
            validateDataInput(title: title, content: content),
            let title = title,
            let content = content,
            let deadline = deadline,
            let status = status
        else { return }
        
        if task.id == 0 {
            taskApiHelper.addTask(title: title,
                                  content: content,
                                  deadline: deadline,
                                  status: status) { [weak self] result in
                guard let self = self else { return }
                
                self.proceedResult(result: result, message: "Task added successfully")
            }
        } else {
            taskApiHelper.editTask(id: "\(task.id)",
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
