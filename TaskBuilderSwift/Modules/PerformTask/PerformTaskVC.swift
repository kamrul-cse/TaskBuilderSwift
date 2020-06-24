//
//  PerformTaskVC.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 MKHG Lab. All rights reserved.
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
    var rows: [TaskRowData] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel = PerformTaskVM()
        viewModel?.delegate = self
        
        viewModel?.resumeTasks()
        viewModel?.refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel?.stop()
    }
    
    deinit {
        print("PerformTaskVC deinit")
    }
}

extension PerformTaskVC: PerformTaskVMDelegate {
    func rowUpdated(rows: [TaskRowData]) {
        self.rows = rows
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

