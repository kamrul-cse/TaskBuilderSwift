//
//  TaskManager.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
//

import Foundation

protocol TaskManagerDelegate: class {
    func updated(task: TaskViewModel?)
    func changed(tasks: [TaskViewModel]?)
}

class TaskManager {
    static let shared = TaskManager()
    
    var tasks: [TaskViewModel] = []
    var queue: OperationQueue?
    
    weak var delegate: TaskManagerDelegate?
    
    func add(task: TaskViewModel?) {
        guard let model = task, tasks.filter( { $0.task.taskName?.lowercased() == model.task.taskName?.lowercased() } ).first == nil else { return }
        model.task.delegate = self
        tasks.append(model)
    }
    
    func remove(task: TaskViewModel?) {
        tasks = tasks.compactMap( { $0.task.taskName == task?.task.taskName ? nil : $0 } )
    }
    
    func removeAll() {
        tasks = []
    }
    
    func initMockData() {
        let wearingShirt = Task(name: "Shirt", estimatedTime: 10, delegate: self)
        let wearingPant = Task(name: "Pant", estimatedTime: 10, delegate: self)
        let wearingTie = Task(name: "Tie", estimatedTime: 10, delegate: self)
        let wearingShoe = Task(name: "Shoe", estimatedTime: 10, delegate: self)
        let goingOffice = Task(name: "Office", estimatedTime: 10, delegate: self)
        
        wearingPant.dependentTasks = [wearingShirt].compactMap( { $0.taskName } )
        
        wearingTie.dependentTasks = [wearingShirt].compactMap( { $0.taskName } )
        
        wearingShoe.dependentTasks = [wearingPant, wearingTie].compactMap( { $0.taskName } )
        
        goingOffice.dependentTasks = [wearingShirt, wearingPant, wearingTie, wearingShoe].compactMap( { $0.taskName } )
        
        tasks.append(TaskViewModel(model: wearingShirt, cell: TaskCell.getCell(task: wearingShirt)))
        tasks.append(TaskViewModel(model: wearingPant, cell: TaskCell.getCell(task: wearingPant)))
        tasks.append(TaskViewModel(model: wearingTie, cell: TaskCell.getCell(task: wearingTie)))
        tasks.append(TaskViewModel(model: wearingShoe, cell: TaskCell.getCell(task: wearingShoe)))
        tasks.append(TaskViewModel(model: goingOffice, cell: TaskCell.getCell(task: goingOffice)))
        
        bindDependency()
    }
    
    func start() {
        queue?.cancelAllOperations()
        queue = OperationQueue()
        
        for task in tasks {
            if task.task.progress == 100 { continue }
            queue?.addOperation(task.task)
        }
    }
    
    func stop() {
        // Encounter stop for all running tasks
        for task in tasks {
            task.task.stopQueued = true
        }
        
        /*
         * save current state
            1. Make a copy of all tasks
            2. assign dependecies
         N.B: We can't do both at a time because some operation can be cancelled or done.
         */
        
        // 1. Make a copy of all tasks
        tasks = tasks.compactMap({ (viewModel) -> TaskViewModel? in
            let task = viewModel.task.newCopy()
            return TaskViewModel(model: task, cell: viewModel.cell)
        })
        // 2. assign dependecies
        tasks = tasks.compactMap({ (viewModel) -> TaskViewModel? in
            for name in viewModel.task.dependentTasks {
                if let task = getTask(by: name), task.task.progress < 100 {
                    viewModel.task.addDependency(task.task)
                }
            }
            
            return viewModel
        })
        
        queue?.cancelAllOperations()
    }
    
    func bindDependency() {
        tasks = tasks.compactMap({ (viewModel) -> TaskViewModel? in
            for name in viewModel.task.dependentTasks {
                if let task = getTask(by: name), task.task.progress < 100 {
                    viewModel.task.addDependency(task.task)
                }
            }
            
            return viewModel
        })
    }
    
    func getTask(by name: String?) -> TaskViewModel? {
        guard let name = name else { return nil }
        return tasks.filter( { $0.task.taskName == name } ).first
    }
}

extension TaskManager: TaskDelegate {
    func progress(task: Task) {
        print("\(task.taskName ?? "Unknown") \(task.progress)")
        let taskVM = tasks.filter { (viewModel) -> Bool in
            return task.taskName == viewModel.task.taskName
        }.first
        delegate?.updated(task: taskVM)
    }
    
    func stateChanged(task: Task) {
        delegate?.changed(tasks: tasks)
    }
}
