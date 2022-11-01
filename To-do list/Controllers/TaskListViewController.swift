//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController,
                              TaskTableViewCellDelegate{
    
    var tasks = [Task]()

    private let taskApiHelper = TaskApiHelper()
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "TaskTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        taskApiHelper.executeTaskList { result in
            if let result = result {
                self.tasks = result
                self.tasksTableView.reloadData()
            }
        }

    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let taskDetailsVC = TaskDetailsViewController.loadFromStoryboard(
            type: TaskDetailsViewController.self)
        taskDetailsVC.task = Task(title: "",
                                  content: "",
                                  deadline: Date.now.formatDate(),
                                  status: .todo,
                                  id: 0)
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func didTapStatusButton(cell: TaskTableViewCell, didClickOnStatus task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index].status = tasks[index].status.nextState
            
            taskApiHelper.editStatusTask(id: "\(task.id)", status: tasks[index].status.rawValue) { result in
                var message = String()
                if let result = result {
                    if result.status == "ok" {
                        self.tasksTableView.reloadData()
                    } else {
                        message = "Session expired"
                    }
                } else {
                    message = "Something went wrong. Please try again."
                    self.tasks[index].status = self.tasks[index].status.backState
                }
                if !message.isEmpty {
                    Alert.showBasicWithTimer(title: message, vc: self)
                }
            }
        }
    }
    
    func taskDetails(_ controller: TaskDetailsViewController, didCreateUpdate task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        tasksTableView.reloadData()
    }
    
    private func sortTasks() {
        tasks = tasks.sorted(by: { $0.status.rawValue > $1.status.rawValue })
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tasksTableView.deselectRow(at: indexPath, animated: true)
        let taskDetailsVC = TaskDetailsViewController.loadFromStoryboard(
            type: TaskDetailsViewController.self)
        taskDetailsVC.task = tasks[indexPath.row]
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            taskApiHelper.deleteTask(id: "\(tasks[indexPath.row].id)") { result in
                var message = String()
                if let result = result {
                    if result.status == "ok"  {
                        message = "Task deleted"
                        self.tasks.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        message = "Session expired"
                    }
                } else {
                    message = "Something went wrong. Please try again."
                }
                Alert.showBasicWithTimer(title: message, vc: self)
            }
        }
    }
}


extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TaskTableViewCell.self)) as? TaskTableViewCell
        else { fatalError() }
        sortTasks()
        cell.configure(tasks[indexPath.row])
        cell.task = tasks[indexPath.row]
        cell.delegate = self
        return cell
    }
}

