//
//  UITextField.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-05.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

extension UITextField{
    
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
    func setLeftRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
