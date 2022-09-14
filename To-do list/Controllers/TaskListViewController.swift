//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController,
                              TaskTableViewCellDelegate,
                              TaskDetailsViewControllerDelegate {
  
    var tasks = [Task]()
    var taskIndex = Int()
    var choosenTableViewCell = Bool()
    
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
        tasksTableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let taskDetailsVC = self.storyboard?.instantiateViewController(
            withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController
        choosenTableViewCell = false
        taskDetailsVC?.choosenTableViewCell = choosenTableViewCell
        taskDetailsVC?.delegate = self
        self.navigationController?.pushViewController(taskDetailsVC!, animated: true)
    }
    
    func didTapStatusButton(cell: TaskTableViewCell) {
        if let chosenIndex = tasksTableView.indexPath(for: cell) {
            var currentStatus = tasks[chosenIndex.row].status
            
            
            switch currentStatus {
            case .inProgress:
                currentStatus = .done
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
            case .done:
                currentStatus = .todo
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
            case .todo:
                currentStatus = .inProgress
                tasks[chosenIndex.row].status = currentStatus
                tasksTableView.reloadData()
            default:
                break
            }
        }
    }
    
    func sendTaskDetails(_: TaskDetailsViewController, didCreateUpdate task: Task) {
        if choosenTableViewCell == false {
            tasks.append(task)
            tasksTableView.reloadData()
        } else {
            tasks[taskIndex] = task
            tasksTableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksTableView.deselectRow(at: indexPath, animated: true)
        let taskDetailsVC = self.storyboard?.instantiateViewController(
            withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController
        taskIndex = indexPath.row
        taskDetailsVC?.task = tasks[indexPath.row]
        choosenTableViewCell = true
        taskDetailsVC?.choosenTableViewCell = choosenTableViewCell
        taskDetailsVC?.delegate = self
        self.navigationController?.pushViewController(taskDetailsVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskTableViewCell",for: indexPath) as? TaskTableViewCell
        else {
            fatalError()
        }
        tasks = tasks.sorted(by: { $0.status!.rawValue > $1.status!.rawValue })
        cell.titleLabel.text = tasks[indexPath.row].title
        cell.descriptionLabel.text = tasks[indexPath.row].description
        cell.deadlineLabel.text = DateFormatter().string(from: tasks[indexPath.row].deadline ?? Date())
        cell.statusButtonOutlet.setTitle(tasks[indexPath.row].status?.rawValue, for: .normal)
        
        switch tasks[indexPath.row].status {
        case .inProgress:
            cell.statusButtonOutlet.backgroundColor = .systemOrange
        case .done:
            cell.statusButtonOutlet.backgroundColor = .systemRed
        case .todo:
            cell.statusButtonOutlet.backgroundColor = .systemGreen
        default:
            break
        }
        cell.delegate = self
        return cell
    }
}

