//
//  StatusButton.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-16.
//

import UIKit

class StatusButton {
    
    static func updateStatus(_ sender: UIButton, _ status: Task.Status) {
        sender.setTitle(status.rawValue, for: .normal)
        
        switch status {
        case .inProgress:
            sender.backgroundColor = .systemOrange
        case .done:
            sender.backgroundColor = .systemRed
        case .todo:
            sender.backgroundColor = .systemGreen            
        }
    }
    
    static func changeStatus(_ status: Task.Status) -> Task.Status {
        var changeStatus = status
        
        switch changeStatus {
        case .todo:
            changeStatus = .inProgress
        case .inProgress:
            changeStatus = .done
        case .done:
            changeStatus = .todo
        }
        return changeStatus
    }
}
