//
//  UITableViewCellExt.swift
//  TaskBuilderSwift
//
//  Created by Md. Kamrul Hasan on 23/6/20.
//  Copyright © 2020 Maya Digital Health Pte. Ltd. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func getCell(title: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = title
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        cell.selectionStyle = .none
        return cell
    }
}
