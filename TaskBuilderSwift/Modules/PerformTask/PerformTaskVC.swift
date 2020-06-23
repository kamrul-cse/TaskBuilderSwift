//
//  PerformTaskVC.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

class PerformTaskVC: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var viewModel: PerformTaskVM?
    var rows: [TaskRowData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PerformTaskVM()
        viewModel?.delegate = self
                
        viewModel?.resumeTasks()
    }
}

extension PerformTaskVC: PerformTaskVMDelegate {
    func rowUpdated(rows: [TaskRowData]) {
        self.rows = rows
        tableView.reloadData()
    }
}

extension PerformTaskVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.row].cell
    }
}

