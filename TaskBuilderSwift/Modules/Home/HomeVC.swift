//
//  HomeVC.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var startButton: UIButton!
    
    var rows: [TaskRowData] = []
    var viewModel: HomeVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeVM()
        viewModel?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.setupData()
        setupViews()
    }
    
    func setupViews() {
        if TaskManager.shared.tasks.count == 0 {
            startButton.setTitle("Simulate Mock Tasks", for: .normal)
        } else {
            startButton.setTitle("Start Tasks", for: .normal)
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if startButton.title(for: .normal) == "Simulate Mock Tasks" {
            TaskManager.shared.initMockData()
        }
    }
    
    @IBAction func trashTapped(_ sender: Any) {
        TaskManager.shared.removeAll()
        viewModel?.setupData()
        setupViews()
    }
}

extension HomeVC: HomeVMDelegate {
    func rowsUpdated(rows: [TaskRowData]) {
        self.rows = rows
        tableView.reloadData()
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.row].cell
    }
}
