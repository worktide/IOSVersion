//
//  AccountSettingsHeader.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-03.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class AccountSettingsHeader:UICollectionReusableView{
    
    private let accountSettingsTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.text = "Account"
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 1
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(accountSettingsTitle)
        accountSettingsTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        accountSettingsTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        accountSettingsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        accountSettingsTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
