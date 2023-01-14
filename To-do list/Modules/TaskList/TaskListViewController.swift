//
//  TaskListViewController.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-08.
//

import UIKit

class TaskListViewController: UIViewController {
       
    private var tasks = [Task]()
    private var viewModel: TaskListViewModelProtocol = TaskListViewModel(api: TaskAPIHelper())
    
    @IBOutlet weak var tasksTableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        subscribeForDataUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load()
    }

    // MARK: - Preparations
    private func registerCell() {
        let reuseId = String(describing: TaskTableViewCell.self)
        tasksTableView.register(UINib(nibName: reuseId, bundle: nil),
                                forCellReuseIdentifier: reuseId)
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }

    private func subscribeForDataUpdates() {
        viewModel.observableState = { [weak self] state in
            guard let self = self else { return }
            var message = String()

            switch state {
            case .loaded(let result):
                self.tasks = result
                self.tasksTableView.reloadData()
            case .failure(let error):
                message = self.parse(error)
            case .deleteTask(let title, let indexPath):
                self.tasks.remove(at: indexPath.row)
                self.tasksTableView.deleteRows(at: [indexPath], with: .fade)
                self.showAlertWithTimer(title: title, vc: self)
            }

            if message != "" {
                self.showBasicAlert(title: message, vc: self)
            }
        }
    }

    // MARK: - Private funcs
    @IBAction private func addButton(_ sender: UIButton) {
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

// MARK: - TaskTableViewCellDelegate funcs
extension TaskListViewController: TaskTableViewCellDelegate {
    func didTapStatusButton(cell: TaskTableViewCell, didClickOnStatus task: Task) {
        viewModel.changeStatus(cell: cell, didClickOnStatus: task)
    }
}

// MARK: - UITableViewDelegate funcs
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
        let reuseId = String(describing: TaskTableViewCell.self)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? TaskTableViewCell else { fatalError() }

        tasks = viewModel.sortTasks(tasks)
        cell.configure(tasks[indexPath.row])
        cell.task = tasks[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

