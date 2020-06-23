//
//  AddTaskVC.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dependencyField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var viewModel: AddTaskVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddTaskVM()
    }

    @IBAction func addTapped(_ sender: Any) {
                
        if let (error, model) = viewModel?.constructTask(name: nameField.text, time: timeField.text, dependency: dependencyField.text) {
            messageLabel.text = error
            messageLabel.isHidden = error == nil
            
            if error == nil {
                TaskManager.shared.add(task: model)
                navigationController?.popViewController(animated: true)
            }

        }
    }
}
