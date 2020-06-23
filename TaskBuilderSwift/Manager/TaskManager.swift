//
//  TaskManager.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    
    var tasks: [TaskModel] = []
    
    func add(task: TaskModel?) {
        guard let model = task, tasks.filter( { $0.name.lowercased() == model.name.lowercased() } ).first == nil else { return }
        
        tasks.append(model)
    }
    
    func remove(task: TaskModel?) {
        tasks = tasks.compactMap( { $0.name == task?.name ? nil : $0 } )
    }
    
    func removeAll() {
        tasks = []
    }
    
    func initMockData() {
        tasks = [
            TaskModel(name: "A", estimatedTime: 10),
            TaskModel(name: "B", estimatedTime: 10, dependencies: ["A"]),
            TaskModel(name: "C", estimatedTime: 15, dependencies: ["A"]),
            TaskModel(name: "D", estimatedTime: 5, dependencies: ["A", "B"]),
            TaskModel(name: "E", estimatedTime: 25, dependencies: ["F"]),
            TaskModel(name: "F", estimatedTime: 10, dependencies: ["B"])
        ]
    }
}
