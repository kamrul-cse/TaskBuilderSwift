//
//  TaskViewModel.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

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
