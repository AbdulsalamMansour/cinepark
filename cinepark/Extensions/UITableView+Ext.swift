//
//  UITableView+Ext.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

extension UITableView {

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
