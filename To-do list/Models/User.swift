//
//  Credentials.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-09.
//

import Foundation

struct User: Codable {
    var login: String
    var password: String
    var task: [Task]?
}
