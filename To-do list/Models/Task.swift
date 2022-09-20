//
//  Task.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-09.
//

import Foundation

struct Task: Codable, Equatable {
    var title: String = ""
    var description: String = ""
    var deadline: Date = .now
    var status: Status = .todo
    var id: Int = 0
    
    enum Status: String, Codable {
        case todo = "to do"
        case inProgress = "in progress"
        case done = "done"
    }
}
