//
//  Date+Extension.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-19.
//

import Foundation

extension Date {
    
    static let formatter = DateFormatter()
    
//    func formatDateToString() -> String {
//        Date.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let myString = Date.formatter.string(from: Date())
//        let myDate = Date.formatter.date(from: myString)
//        Date.formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        return Date.formatter.string(from: myDate!)
//    }
    
    func formatDate() -> String {
        Date.formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return Date.formatter.string(from: self)
    }
   
}
