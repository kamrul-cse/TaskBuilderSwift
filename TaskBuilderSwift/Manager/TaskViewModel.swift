//
//  TaskViewModel.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
//

import UIKit

class TaskViewModel {
    var task: Task
    var cell: TaskCell
    
    init(model: Task, cell: TaskCell) {
        self.task = model
        self.cell = cell
    }
}
