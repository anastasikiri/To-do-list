//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController,
                              TaskTableViewCellDelegate{
    
    private var tasks = [Task]()
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
        
        taskApiHelper.executeTaskList { [weak self] result in
            guard let self = self else { return }
            var message = String()
            
            switch result {
            case .success(let result):
                self.tasks = result
                self.tasksTableView.reloadData()
            case .failure(let error):
                message = self.parse(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showAlertWithTimer(title: message, vc: self)
                }
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
            
            taskApiHelper.editStatusTask(id: "\(task.id)",
                                         status: tasks[index].status.rawValue) { [weak self] result in
                guard let self = self else { return }
                var message = String()
                
                switch result {
                case .success(_):
                    self.tasksTableView.reloadData()
                case.failure(let error):
                    self.tasks[index].status = self.tasks[index].status.backState
                    message = self.parse(error)
                    self.showAlertWithTimer(title: message, vc: self)
                }
            }
        }
    }
    
    private func taskDetails(_ controller: TaskDetailsViewController, didCreateUpdate task: Task) {
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
            
            taskApiHelper.deleteTask(id: "\(tasks[indexPath.row].id)") { [weak self] result in
                guard let self = self else { return }
                var message = String()
                
                switch result {
                case .success(_):
                    message = "Task deleted"
                    self.tasks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    message = self.parse(error)
                }
                self.showAlertWithTimer(title: message, vc: self)
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

