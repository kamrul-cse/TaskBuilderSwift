//
//  Task.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
//

import Foundation

protocol TaskDelegate: class {
    func progress(task: Task)
    func stateChanged(task: Task)
}

class Task: Operation {
    var taskName: String?
    var estimatedTime: Float = 0
    var progress: Float = 0
    var dependentTasks: [String] = []
    var stopQueued = false
    
    weak var delegate: TaskDelegate?
    
    init(name: String?, estimatedTime: Float, delegate: TaskDelegate?) {
        self.taskName = name
        self.estimatedTime = estimatedTime
        self.delegate = delegate
    }
    
    init(name: String?, progress: Float, estimatedTime: Float, dependencies: [String], delegate: TaskDelegate?) {
        super.init()
        self.taskName = name
        self.progress = progress
        self.dependentTasks = dependencies
        self.estimatedTime = estimatedTime
        self.delegate = delegate
    }
    
    init(name: String?, estimatedTime: Float, dependencies: [String]) {
        self.taskName = name
        self.estimatedTime = estimatedTime
        self.dependentTasks = dependencies
    }
    
    func newCopy() -> Task {
        let task = Task(name: taskName, progress: progress, estimatedTime: estimatedTime, dependencies: dependentTasks, delegate: delegate)
        return task
    }
    
    override func main() {
        let initialValue = max((progress/100) * estimatedTime, 1)
        for i in Int(initialValue)...Int(estimatedTime) {
            if stopQueued { print("\(taskName ?? "Unknown") stopped XXXXXXXXXXXXXXXXXXXXXXXXX"); cancel(); return }
            let value = (Float(i)/estimatedTime) * 100
            self.progress = value
            
            if i == Int(initialValue) || progress == 100 {
                print("\(taskName ?? "Unknown") stateChanged ------------------------------")
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.delegate?.progress(task: self)
                    self.delegate?.stateChanged(task: self)
                }
            } else {
                print("\(taskName ?? "Unknown") progress \(progress)")
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.delegate?.progress(task: self)
                }
            }
            
            sleep(1)
        }
    }
}
