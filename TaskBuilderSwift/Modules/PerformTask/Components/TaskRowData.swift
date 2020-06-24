//
//  TaskRowData.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
//

import UIKit

class TaskRowData {
    var type: TaskRowType
    var model: Any
    var cell: UITableViewCell
    
    init(type: TaskRowType, model: Any, cell: UITableViewCell) {
        self.type = type
        self.model = model
        self.cell = cell
    }
}
