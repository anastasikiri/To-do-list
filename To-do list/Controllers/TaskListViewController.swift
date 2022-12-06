//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController, TaskTableViewCellDelegate {
       
    private var tasks = [Task]()
    private var message = String()
    private var viewModel: TaskListModelProtocol = TaskListModel(client: TaskApiHelper())
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "TaskTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        viewModel.observableState = { [weak self] state in
            switch state {
            case .loaded(let result):
                self?.tasks = result
                self?.tasksTableView.reloadData()
                self?.message = String()
            case .failure(let error):
                self?.message = self?.parse(error) ?? ""
            case .deletedask(let title, let indexPath):
                self?.tasks.remove(at: indexPath.row)
                self?.tasksTableView.deleteRows(at: [indexPath], with: .fade)
                self?.showAlertWithTimer(title: title, vc: self!)
            }
            if self?.message != "" {
                self?.showBasicAlert(title: self!.message, vc: self!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.load()
    }
    
    func didTapStatusButton(cell: TaskTableViewCell, didClickOnStatus task: Task) {
        viewModel.changeStatus(cell: cell, didClickOnStatus: task)
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
            viewModel.deleteTask(indexPath: indexPath)
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
        tasks = viewModel.sortTasks(tasks)
        cell.configure(tasks[indexPath.row])
        cell.task = tasks[indexPath.row]
        cell.delegate = self
        return cell
    }
}

