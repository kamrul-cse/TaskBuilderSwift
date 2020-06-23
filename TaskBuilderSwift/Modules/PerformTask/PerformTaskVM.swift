//
//  PerformTaskVM.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

protocol PerformTaskVMDelegate: class {
    func rowUpdated(rows: [TaskRowData])
}

class PerformTaskVM {
    
    weak var delegate: PerformTaskVMDelegate?
    var taskViewModels: [TaskViewModel] = []
    var rows: [TaskRowData] = []
    
    init() {
        taskViewModels = TaskManager.shared.tasks.compactMap( { TaskViewModel(model: $0, cell: TaskCell.getCell(task: $0)) } )
    }
    
    func setupData(models: [TaskViewModel]?) {
        guard let models = models else { return }
        rows = []
        let taskViewModels = models
        let pendingList = taskViewModels.compactMap( { ($0.model.progress == 0 && !($0.timer?.isValid ?? false)) ? TaskRowData(type: .pending, model: $0, cell: $0.cell) : nil } )
        if pendingList.count > 0 {
            let ext = pendingList.count == 1 ? "" : "s"
            rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Pending Task\(ext)")))
            rows.append(contentsOf: pendingList)
        }
        let runningList = taskViewModels.compactMap( { ($0.timer?.isValid ?? false) ? TaskRowData(type: .running, model: $0, cell: $0.cell) : nil } )
        if runningList.count > 0 {
            let ext = runningList.count == 1 ? "" : "s"
            rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Running Task\(ext)")))
            rows.append(contentsOf: runningList)
        }
        let completedList = taskViewModels.compactMap( { $0.model.progress == 100 ? TaskRowData(type: .completed, model: $0, cell: $0.cell) : nil } )
        if completedList.count > 0 {
            let ext = completedList.count == 1 ? "" : "s"
            rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Completed Task\(ext)")))
            rows.append(contentsOf: completedList)
        }
        
        delegate?.rowUpdated(rows: rows)
    }
    
    //start or resume tasks
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

    //start stask
    func start(task: TaskViewModel) {
        
        let timeInterval: TimeInterval = 0.5
        task.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] (timer) in
            guard let `self` = self else { return }
            let value = (Float(timeInterval)/task.model.estimatedTime) * 100
            task.model.progress += value
            task.model.progress = min(task.model.progress, 100)
            print("\(task.model.name) task.progress \(task.model.progress)" )
            if task.model.progress == 100 {
                timer.invalidate()
                self.complete(task: task)
            }
            task.cell.configure(model: task.model)
        }
        print("\(task.model.name) started ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
        
        setupData(models: taskViewModels)
    }
    
    //finish task
    func complete(task: TaskViewModel) {
        print("\(task.model.name) finished ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑")
        let pendingList = self.taskViewModels.compactMap( { $0.model.progress == 100 ? nil : $0 } )
        let completedSortedList = self.taskViewModels.compactMap( { $0.model.progress == 100 ? $0 : nil } ).sorted { (task1, task2) -> Bool in
            return task1.model.estimatedTime < task2.model.estimatedTime
        }
        taskViewModels = pendingList + completedSortedList
        resumeTasks()
        
        setupData(models: taskViewModels)
    }
}
