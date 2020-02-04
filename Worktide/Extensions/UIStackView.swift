//
//  UIStackView.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-09.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
