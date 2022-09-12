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
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusButton(_ sender: UIButton) {
        delegate?.didTapStatusButton(cell: self)
    }
}
