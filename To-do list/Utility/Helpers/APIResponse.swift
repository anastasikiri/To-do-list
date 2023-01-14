//
//  APIResponse.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-10-24.
//

import Foundation

struct LoginResponse: Codable {
    var token: String?
}

struct NetworkResponse: Codable {
    var status: String?
}

struct TaskResponse: Codable {
    let status: String
    let task: Task?
}

struct ErrorResponse: Codable {
    let details: String
}

