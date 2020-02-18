//
//  AboutServiceCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-08.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class AboutServiceCell:UICollectionViewCell{
    
    public let jobDesciption: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
        self.addSubview(jobDesciption)
        jobDesciption.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        jobDesciption.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        jobDesciption.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
