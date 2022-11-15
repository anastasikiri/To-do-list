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
        Date.formatter.dateFormat = Constants.dataWithoutSec
        return Date.formatter.string(from: self)
    }
}
