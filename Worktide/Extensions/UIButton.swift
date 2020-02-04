//
//  UIButton.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-08.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}
