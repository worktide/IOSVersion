//
//  UIImageView.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

public extension UIImageView {

    func addInitials(initial:String, textSize:CGFloat) {
        let initials = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        initials.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        initials.textAlignment = .center
        initials.text = initial
        initials.font = UIFont(name: "AppleSDGothicNeo-Bold", size: textSize)
        initials.textColor = .white
        self.addSubview(initials)
    }
    
}
