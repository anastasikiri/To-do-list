//
//  TaskDetailsViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func statusButton(_ sender: UIButton) {
        counter += 1
        switch counter {
        case 1:
            sender.backgroundColor = .systemOrange
            sender.setTitle("in progress", for: .normal)
            // do your action
        case 2:
            sender.backgroundColor = .systemRed
            sender.setTitle("done", for: .normal)
            // do your action
        case 3:
            sender.backgroundColor = .systemGreen
            sender.setTitle("to do", for: .normal)
            counter = 0
            // do your action
            
        default:
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
