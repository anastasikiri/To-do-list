//
//  String+Extension.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-26.
//

import Foundation

extension String {
    
    var isValidEmail : Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func getDate() -> Date? {
        Date.formatter.dateFormat = Constants.dataWithSec
        return Date.formatter.date(from: self)
    }
    
    func convertToDateFormat(current: String, convertTo: String) -> String {
        Date.formatter.dateFormat = current
        guard let date = Date.formatter.date(from: self) else { return self }
        Date.formatter.dateFormat = convertTo
        return  Date.formatter.string(from: date)
    }
}
