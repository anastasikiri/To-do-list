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
    
    private var tasks = [Task]()
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "TaskTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
      
    @IBAction func addButton(_ sender: UIButton) {
        let taskDetailsVC = TaskDetailsViewController.loadFromStoryboard(
            type: TaskDetailsViewController.self)
        taskDetailsVC.task = Task(title: "",
                                  description: "",
                                  deadline: .now,
                                  status: .todo,
                                  id: tasks.count+1)
        taskDetailsVC.delegate = self
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func didTapStatusButton(cell: TaskTableViewCell) {
        if let chosenIndex = tasksTableView.indexPath(for: cell) {                       
            tasks[chosenIndex.row].status = tasks[chosenIndex.row].status.nextState
        }
        tasksTableView.reloadData()
    }
    
    func taskDetails(_ controller: TaskDetailsViewController, didCreateUpdate task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        tasksTableView.reloadData()
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tasksTableView.deselectRow(at: indexPath, animated: true)
        let taskDetailsVC = TaskDetailsViewController.loadFromStoryboard(
            type: TaskDetailsViewController.self)
        taskDetailsVC.task = tasks[indexPath.row]
        taskDetailsVC.delegate = self
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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
        tasks = tasks.sorted(by: { $0.status.rawValue > $1.status.rawValue })
        cell.configure(tasks[indexPath.row])
        cell.delegate = self
        return cell
    }
}

