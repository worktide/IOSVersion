//
//  UITableView.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-30.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

extension UITableView {

var isTableHeaderViewVisible: Bool {
        guard let tableHeaderView = tableHeaderView else {
            return false
        }

        let currentYOffset = self.contentOffset.y;
        let headerHeight = tableHeaderView.frame.size.height;

        return currentYOffset < headerHeight
    }
    
}
