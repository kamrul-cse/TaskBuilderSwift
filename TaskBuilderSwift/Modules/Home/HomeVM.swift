//
//  HomeVM.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
//

import UIKit

protocol HomeVMDelegate: class {
    func rowsUpdated(rows: [TaskRowData])
}

class HomeVM {
    var rows: [TaskRowData] = []
    
    weak var delegate: HomeVMDelegate?
    
    func setupData() {
        rows = []
        if TaskManager.shared.tasks.count == 0 {
            rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "No tasks found")))
        } else {
            let taskViewModels = TaskManager.shared.tasks.compactMap( { TaskViewModel(model: $0.task, cell: TaskCell.getCell(task: $0.task)) } )
            let pendingList = taskViewModels.compactMap( { ($0.task.progress == 0) ? TaskRowData(type: .pending, model: $0, cell: $0.cell) : nil } )
            if pendingList.count > 0 {
                let ext = pendingList.count == 1 ? "" : "s"
                rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Pending Task\(ext)")))
                rows.append(contentsOf: pendingList)
            }
            let runningList = taskViewModels.compactMap( { ($0.task.progress > 0 && $0.task.progress < 100) ? TaskRowData(type: .running, model: $0, cell: $0.cell) : nil } )
            if runningList.count > 0 {
                let ext = runningList.count == 1 ? "" : "s"
                rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Running Task\(ext)")))
                rows.append(contentsOf: runningList)
            }
            let completedList = taskViewModels.compactMap( { $0.task.progress == 100 ? TaskRowData(type: .completed, model: $0, cell: $0.cell) : nil } )
            if completedList.count > 0 {
                let ext = completedList.count == 1 ? "" : "s"
                rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Completed Task\(ext)")))
                rows.append(contentsOf: completedList)
            }
        }
        delegate?.rowsUpdated(rows: rows)
    }
    
    func haveRunningTask() -> Bool {
        return TaskManager.shared.tasks
            .compactMap( { TaskViewModel(model: $0.task, cell: TaskCell.getCell(task: $0.task)) } )
            .compactMap( { ($0.task.progress > 0 && $0.task.progress < 100) ? TaskRowData(type: .running, model: $0, cell: $0.cell) : nil } ).count > 0
    }
}
