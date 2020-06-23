//
//  AddTaskVM.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import Foundation

class AddTaskVM {
    
    func constructTask(name: String?, time: String?, dependency: String?) -> (error: String?, model: TaskModel?) {
        var error: String?
        var model: TaskModel?
        
        var taskName: String = ""
        var taskEstimatedTime: Float = 0
        var taskDependencies: [String] = []
        
        if let name = name, name.count > 0 {
            taskName = name
        } else {
            error = "Invalid task name"
            return (error, model)
        }
        if let time = time, time.count > 0 {
            taskEstimatedTime = Float(time) ?? 0
        } else {
            error = "Invalid estimated time"
            return (error, model)
        }
        if let dependency = dependency?.replacingOccurrences(of: " ", with: ""), dependency.count > 0 {
            taskDependencies = dependency.split(separator: ",").compactMap( { String($0) } )
            if taskDependencies.filter( { $0.lowercased() == taskName.lowercased() } ).first != nil {
                error = "Invalid dependecy"
                return (error, model)
            }
        } else {
            // this is optional
            // so let it go optional
        }
        
        model = TaskModel(name: taskName, estimatedTime: taskEstimatedTime, dependencies: taskDependencies)
        return (error, model)
    }
}
