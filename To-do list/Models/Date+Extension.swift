//
//  Date+Extension.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-19.
//

import Foundation

extension Date {
    
    func formatDate (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
