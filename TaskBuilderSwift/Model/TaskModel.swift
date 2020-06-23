//
//  TaskModel.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import Foundation

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
