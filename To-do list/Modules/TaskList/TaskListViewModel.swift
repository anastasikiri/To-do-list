//
//  File.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-12-03.
//

import Foundation

enum TaskListViewModelState {
    case loaded([Task])
    case failure(APIHelper.ErrorAPI)
    case deleteTask(String, IndexPath)
}

protocol TaskListViewModelProtocol {
    func load()
    func changeStatus(cell: TaskTableViewCell, didClickOnStatus task: Task)
    func sortTasks(_ tasks: [Task]) -> [Task]
    func deleteTask(indexPath: IndexPath)
    
    var observableState: ((TaskListViewModelState) -> Void)? { get set }
}

class TaskListViewModel: TaskListViewModelProtocol {
    
    private let api: TaskAPIHelperProtocol
    private var tasks = [Task]()

    var observableState: ((TaskListViewModelState) -> Void)?

    init(api: TaskAPIHelperProtocol) {
        self.api = api
    }

    // MARK: - Public funcs
    func load() {
        api.loadTasks { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let result):
                self.observableState?(.loaded(result))
                self.tasks = result
            case .failure(let error):
                self.observableState?(.failure(error))
            }
        }
        
    }
    
    func changeStatus(cell: TaskTableViewCell, didClickOnStatus task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index].status = tasks[index].status.nextState
            
            api.editTaskStatus(id: "\(task.id)",
                               status: tasks[index].status.rawValue) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    self.load()
                case.failure(let error):
                    self.tasks[index].status = self.tasks[index].status.backState
                    self.observableState?(.failure(error))
                }
            }
        }
    }
    
    func sortTasks(_ tasks: [Task]) -> [Task] {
       tasks.sorted(by: { $0.status.rawValue > $1.status.rawValue })
    }
    
    func deleteTask(indexPath: IndexPath) {
        api.deleteTask(id: "\(tasks[indexPath.row].id)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let message = "Task deleted"
                self.observableState?(.deleteTask(message, indexPath))
            case .failure(let error):
                self.observableState?(.failure(error))
            }
        }
    }
    
}
