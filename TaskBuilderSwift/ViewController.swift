//
//  PerformTaskVC.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

class TaskModel {
    var name: String
    var estimatedTime: Float
    var progress: Float = 0
    var dependencies: [String] = []
    
    init(name: String, estimatedTime: Float) {
        self.name = name
        self.estimatedTime = estimatedTime
    }
    
    init(name: String, estimatedTime: Float, dependencies: [String]) {
        self.name = name
        self.estimatedTime = estimatedTime
        self.dependencies = dependencies
    }
}

class TaskViewModel {
    var model: TaskModel
    var timer: Timer? = nil
    var cell: TaskCell
    
    init(model: TaskModel, cell: TaskCell) {
        self.model = model
        self.cell = cell
        self.timer = nil
    }
}

enum RowType {
    case header
    case pending
    case running
    case completed
}
struct RowData {
    var type: RowType
    var model: Any
    var cell: UITableViewCell
}

class PerformTaskVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var taskViewModels: [TaskViewModel] = []
    var rows: [RowData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskViewModels = TaskManager.shared.tasks.compactMap( { TaskViewModel(model: $0, cell: TaskCell.getCell(task: $0)) } )
        
        setupData()
        resumeTasks()
    }
    
    func setupData() {
        rows = []
        
        let pendingList = taskViewModels.compactMap( { ($0.model.progress == 0 && !($0.timer?.isValid ?? false)) ? RowData(type: .pending, model: $0, cell: $0.cell) : nil } )
        if pendingList.count > 0 {
            let ext = pendingList.count == 1 ? "" : "s"
            rows.append(RowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Pending Task\(ext)")))
            rows.append(contentsOf: pendingList)
        }
        let runningList = taskViewModels.compactMap( { ($0.timer?.isValid ?? false) ? RowData(type: .running, model: $0, cell: $0.cell) : nil } )
        if runningList.count > 0 {
            let ext = runningList.count == 1 ? "" : "s"
            rows.append(RowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Running Task\(ext)")))
            rows.append(contentsOf: runningList)
        }
        let completedList = taskViewModels.compactMap( { $0.model.progress == 100 ? RowData(type: .completed, model: $0, cell: $0.cell) : nil } )
        if completedList.count > 0 {
            let ext = completedList.count == 1 ? "" : "s"
            rows.append(RowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Completed Task\(ext)")))
            rows.append(contentsOf: completedList)
        }
        
        tableView.reloadData()
    }
    

    //problem solution
    func resumeTasks() {
        for task in taskViewModels {
            if (task.timer?.isValid ?? false) || task.model.progress == 100 {
                // case 1. already running
                // case 2. completed task
                print("\(task.model.name) already running or completed")
                continue
            }
            else if task.model.dependencies.count > 0 {
                //have dependency
                let dependencies = task.model.dependencies.compactMap( { name -> TaskViewModel? in
                    taskViewModels.filter( { $0.model.name.lowercased() == name.lowercased() } ).first
                } ).filter( { $0.model.progress < 100 } )
                if dependencies.count > 0 {
                    //waiting for someone
                    print("\(task.model.name) can't start now")
                } else {
                    //dependency resolved
                    start(task: task)
                }
            } else if task.model.progress == 0 || (!(task.timer?.isValid ?? false) && task.model.progress > 0) {
                // case 1. no dependency and not started yet
                // case 2. already have some progress but stopped
                //         so lets resume
                start(task: task)
            } else {
                // already finished
                // nothing to do
            }
        }
    }

    func start(task: TaskViewModel) {
        task.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let `self` = self else { return }
            let value = (1/task.model.estimatedTime) * 100
            task.model.progress += value
            task.model.progress = min(task.model.progress, 100)
            print("\(task.model.name) task.progress \(task.model.progress)" )
            if task.model.progress == 100 {
                timer.invalidate()
                self.taskDone(task: task)
            }
            task.cell.configure(model: task.model)
        }
        print("\(task.model.name) started")
        setupData()
    }
    
    func taskDone(task: TaskViewModel) {
        print("\(task.model.name) finished")
        let pending = self.taskViewModels.compactMap( { $0.model.progress == 100 ? nil : $0 } )
        let sortedCompletedTaskList = self.taskViewModels.compactMap( { $0.model.progress == 100 ? $0 : nil } ).sorted { (task1, task2) -> Bool in
            return task1.model.estimatedTime < task2.model.estimatedTime
        }
        var list: [TaskViewModel] = []
        list.append(contentsOf: pending)
        list.append(contentsOf: sortedCompletedTaskList)
        taskViewModels = list
        setupData()
        self.resumeTasks()
    }
}

extension PerformTaskVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.row].cell
    }
}

