//
//  Date+Extension.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-19.
//

import Foundation

extension Date {
    
    static let formatter = DateFormatter()
    
    func formatDate() -> String {
        Date.formatter.dateFormat = "yyyy-MM-dd"
        return Date.formatter.string(from: self)
    }
}
