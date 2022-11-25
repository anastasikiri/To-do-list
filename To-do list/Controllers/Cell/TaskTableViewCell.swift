//
//  TaskTableViewCell.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-09.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didTapStatusButton(cell: TaskTableViewCell, didClickOnStatus task: Task)
}

class TaskTableViewCell: UITableViewCell {
    
    var task : Task?
    weak var delegate: TaskTableViewCellDelegate?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var deadlineLabel: UILabel!
    @IBOutlet private weak var statusButton: UIButton!
    
    @IBAction func tapStatusButton(_ sender: UIButton) {
        if let task = task {
            self.delegate?.didTapStatusButton(cell: self, didClickOnStatus: task)}
    }
    
    func configure(_ task: Task) {
        titleLabel.text = task.title
        contentLabel.text = task.content
        deadlineLabel.text = task.deadline.convertToDateFormat(current: Constants.DateFormat.dateWithSec,
                                                               convertTo: Constants.DateFormat.dateWithoutSec)
        statusButton.setTitle(task.status.rawValue, for: .normal)
        
        switch task.status {
        case .inProgress:
            statusButton.backgroundColor = .systemOrange
        case .done:
            statusButton.backgroundColor = .systemRed
        case .todo:
            statusButton.backgroundColor = .systemGreen
        }
    }
}
