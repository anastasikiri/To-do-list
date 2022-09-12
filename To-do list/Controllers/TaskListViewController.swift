//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController, TaskTableViewCellDelegate {
    
    var userIndex = Int()
    var users = [User]()
    var tasks = [Task]()
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "TaskTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = UserDefaultsManager.shared.getValueForUser() ?? [User]()
        tasks = users[userIndex].task ?? [Task]()
        tasksTableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let taskDetailsVC = self.storyboard?.instantiateViewController(
            withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController
        taskDetailsVC?.userIndex = userIndex
        taskDetailsVC?.choosenTableViewCell = false
        self.navigationController?.pushViewController(taskDetailsVC!, animated: true)
    }
    
    func didTapStatusButton(cell: TaskTableViewCell) {
        if let chosenIndex = tasksTableView.indexPath(for: cell) {
            var currentStatus = tasks[chosenIndex.row].status
            
            
            switch currentStatus {
            case "in progress":
                currentStatus = "done"
                print("current status: \(currentStatus)")
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
                users[userIndex].task?[chosenIndex.row].status = currentStatus
                UserDefaultsManager.shared.setValueForUser(value: users)
            case "done":
                currentStatus = "to do"
                print("current status: \(currentStatus)")
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
                users[userIndex].task?[chosenIndex.row].status = currentStatus
                UserDefaultsManager.shared.setValueForUser(value: users)
            case "to do":
                currentStatus = "in progress"
                print("current status: \(currentStatus)")
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
                users[userIndex].task?[chosenIndex.row].status = currentStatus
                UserDefaultsManager.shared.setValueForUser(value: users)
            default:
                break
            }
        }
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksTableView.deselectRow(at: indexPath, animated: true)
        let taskDetailsVC = self.storyboard?.instantiateViewController(
            withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController
        taskDetailsVC?.userIndex = userIndex
        taskDetailsVC?.taskIndex = indexPath.row
        taskDetailsVC?.choosenTableViewCell = true
        self.navigationController?.pushViewController(taskDetailsVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            users[userIndex].task?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaultsManager.shared.setValueForUser(value: users)
            tableView.endUpdates()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return users[userIndex].task?.count ?? 0
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskTableViewCell",for: indexPath) as? TaskTableViewCell
        else {
            fatalError()
        }
        tasks = tasks.sorted(by: { $0.status > $1.status })
        users[userIndex].task = tasks
        UserDefaultsManager.shared.setValueForUser(value: users)
        cell.titleLabel.text = tasks[indexPath.row].title
        cell.descriptionLabel.text = tasks[indexPath.row].description
        cell.deadlineLabel.text = tasks[indexPath.row].deadline
        cell.statusButtonOutlet.setTitle(tasks[indexPath.row].status, for: .normal)
        
        switch tasks[indexPath.row].status {
        case "in progress":
            cell.statusButtonOutlet.backgroundColor = .systemOrange
        case "done":
            cell.statusButtonOutlet.backgroundColor = .systemRed
        case "to do":
            cell.statusButtonOutlet.backgroundColor = .systemGreen
        default:
            break
        }
        cell.delegate = self
        return cell
    }
}

