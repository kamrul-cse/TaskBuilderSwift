//
//  TaskCell.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    public static let nibName = "TaskCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var model: TaskModel? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        progressView.setProgress(0, animated: false)
    }
    
    public func configure(model: TaskModel?) {
        guard let model = model else { return }
        self.model = model
    }
    
    func setupData() {
        guard let model = model else { return }
        titleLabel.text = model.name
        progressView.setProgress(model.progress/100, animated: true)
        let progress = String(format: "%.1f", model.progress)
        let message = model.progress == 100 ? "Done" : model.progress > 0 ? "\(progress)%" :  model.dependencies.count > 0 ? "Waiting for \(model.dependencies.joined(separator: ", "))" : ""
        progressLabel.text = message
        progressView.isHidden = model.progress == 100
    }
    
    public static func getNib() -> UINib {
        return UINib(nibName: TaskCell.nibName, bundle: Bundle.main)
    }
    
    public static func getCell(task: TaskModel? = nil) -> TaskCell {
        guard let cell = Bundle.main.loadNibNamed(TaskCell.nibName, owner: self, options: nil)?.first as? TaskCell else { return TaskCell() }
        cell.configure(model: task)
        return cell
    }
    
}
