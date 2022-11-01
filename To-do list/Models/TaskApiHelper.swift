//
//  TaskApiHelper.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-10-29.
//

import Foundation

final class TaskApiHelper {
    
    let apiHelper = APIHelper()
    
    enum TaskMethod {
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
    
    func executeTaskList(completion:@escaping ([Task]?) -> Void) {
        apiHelper.createGetRequest(query: TaskMethod.allTask.path, completion: completion)
    }
    
    func deleteTask(id: String,
                    completion: @escaping (NetworkResponse?) -> Void ){
        apiHelper.createPostRequest(query: TaskMethod.deleteTask.path,
                                    params: ["id": id],
                                    completion: completion)
    }
    
    func addTask(title: String,
                 content: String,
                 deadline: String,
                 status: String,
                 completion: @escaping (TaskResponse?) -> Void){
        apiHelper.createPostRequest(query: TaskMethod.addTask.path, params: ["title" : title,
                                                                             "content": content,
                                                                             "deadline": deadline,
                                                                             "status": status], completion: completion)
    }
    
    func editTask( id: String,
                   title: String,
                   content: String,
                   deadline: String,
                   status: String,
                   completion: @escaping (TaskResponse?) -> Void){
        apiHelper.createPostRequest(query: TaskMethod.editTask.path, params: [ "id":id,
                                                                               "title" : title,
                                                                               "content": content,
                                                                               "deadline": deadline,
                                                                               "status": status], completion: completion)
    }
    
    func editStatusTask( id: String,
                         status: String,
                         completion: @escaping (TaskResponse?) -> Void){
        apiHelper.createPostRequest(query: TaskMethod.editTask.path, params: [ "id":id,
                                                                               "status": status], completion: completion)
    }
}
