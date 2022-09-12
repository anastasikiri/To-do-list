//
//  Task.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-09.
//

import Foundation

struct Task: Codable {
    var title: String
    var description: String
    var deadline: String
    var status: String
}
