//
//  TaskApiHelper.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-10-29.
//

import Foundation

protocol TaskAPIHelperProtocol {
    func loadTasks(completion:@escaping (Result <[Task], APIHelper.ErrorAPI>) -> Void)
    func deleteTask(id: String,
                    completion: @escaping (Result <NetworkResponse, APIHelper.ErrorAPI>) -> Void)
    func createTask(title: String,
                    content: String,
                    deadline: String,
                    status: String,
                    completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void)
    func editTask(id: String,
                  title: String,
                  content: String,
                  deadline: String,
                  status: String,
                  completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void)
    func editTaskStatus(id: String,
                        status: String,
                        completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void)
}

class TaskAPIHelper: APIHelper, TaskAPIHelperProtocol {

    private enum TaskMethod {
        case allTask
        case addTask
        case editTask
        case deleteTask
        var path: String {
            switch self {
            case .allTask: return "task/all"
            case .addTask: return "task"
            case .editTask: return "task/update"
            case .deleteTask: return "task/delete"
            }
        }
    }
    
    func loadTasks(completion:@escaping (Result <[Task], APIHelper.ErrorAPI>) -> Void) {
        self.createGetRequest(query: TaskMethod.allTask.path, completion: completion)
    }
    
    func deleteTask(id: String, completion: @escaping (Result <NetworkResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: TaskMethod.deleteTask.path,
                               params: ["id": id],
                               completion: completion)
    }
    
    func createTask(title: String,
                    content: String,
                    deadline: String,
                    status: String,
                    completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: TaskMethod.addTask.path,
                               params: ["title" : title,
                                        "content": content,
                                        "deadline": deadline,
                                        "status": status],
                                completion: completion)
    }
    
    func editTask(id: String,
                  title: String,
                  content: String,
                  deadline: String,
                  status: String,
                  completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: TaskMethod.editTask.path,
                               params: ["id": id,
                                        "title": title,
                                        "content": content,
                                        "deadline": deadline,
                                        "status": status],
                               completion: completion)
    }
    
    func editTaskStatus(id: String,
                        status: String,
                        completion: @escaping (Result <TaskResponse, APIHelper.ErrorAPI>) -> Void) {
        self.createPostRequest(query: TaskMethod.editTask.path,
                               params: ["id": id,
                                        "status": status],
                                completion: completion)
    }
}
