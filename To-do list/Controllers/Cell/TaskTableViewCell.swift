//
//  TaskTableViewCell.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-09.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didTapStatusButton(cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    weak var delegate: TaskTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    

    @IBAction func statusButton(_ sender: UIButton) {
        delegate?.didTapStatusButton(cell: self)
    }
    
    func configure(_ task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        deadlineLabel.text = task.deadline.formatDate(date: task.deadline)
        StatusButton.updateStatus(statusButtonOutlet, task.status)
    }
}
