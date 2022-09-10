//
//  TaskTableViewCell.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-09.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func statusButton(_ sender: UIButton) {
        counter += 1
        switch counter {
        case 1:
            sender.backgroundColor = .systemOrange
            sender.setTitle("in progress", for: .normal)
            
        case 2:
            sender.backgroundColor = .systemRed
            sender.setTitle("done", for: .normal)
            
        case 3:
            sender.backgroundColor = .systemGreen
            sender.setTitle("to do", for: .normal)
            counter = 0
            
            
        default:
            break
        }
    }
    
}
