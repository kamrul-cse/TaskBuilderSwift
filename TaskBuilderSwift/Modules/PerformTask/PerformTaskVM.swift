//
//  PerformTaskVM.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
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
        TaskManager.shared.delegate = self
        taskViewModels = TaskManager.shared.tasks.compactMap( { TaskViewModel(model: $0.task, cell: TaskCell.getCell(task: $0.task)) } )
    }
    
    deinit {
        print("PerformTaskVM deinit")
    }
    
    func refreshData() {
        rows = []
        
        let pendingList = taskViewModels.compactMap( { ($0.task.progress == 0 && !$0.task.isExecuting) ? TaskRowData(type: .pending, model: $0, cell: $0.cell) : nil } )
        if pendingList.count > 0 {
            let ext = pendingList.count == 1 ? "" : "s"
            rows.append(TaskRowData(type: .header, model: "", cell: UITableViewCell.getCell(title: "Pending Task\(ext)")))
            rows.append(contentsOf: pendingList)
        }
        let runningList = taskViewModels.compactMap( { ($0.task.progress < 100 && $0.task.isExecuting) ? TaskRowData(type: .running, model: $0, cell: $0.cell) : nil } )
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
        delegate?.rowUpdated(rows: rows)
    }
    
    func resumeTasks() {
        TaskManager.shared.start()
    }
    
    func stop() {
        TaskManager.shared.stop()
    }
}

extension PerformTaskVM: TaskManagerDelegate {
    func updated(task: TaskViewModel?) {
        task?.cell.configure(model: task?.task)
    }
    func changed(tasks: [TaskViewModel]?) {
        guard let viewModels = tasks else { return }
        taskViewModels = viewModels
        refreshData()
    }
}
