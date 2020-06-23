//
//  RowData.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

struct RowData<T, K> {
    var type: K
    var model: T
    var cell: UITableViewCell
}

protocol DataModel {
    
}
