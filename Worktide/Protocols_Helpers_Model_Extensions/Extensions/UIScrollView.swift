//
//  UIScrollView.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-08-27.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
