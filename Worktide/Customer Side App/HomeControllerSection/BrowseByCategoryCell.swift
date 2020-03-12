//
//  BroseByCategoryCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-06.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class BrowseByCategoryCell:UICollectionViewCell{
    
    public let iconCategory:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let categoryTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 1
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        self.addSubview(iconCategory)
        iconCategory.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        iconCategory.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        iconCategory.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconCategory.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(categoryTitle)
        categoryTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryTitle.topAnchor.constraint(equalTo: iconCategory.bottomAnchor, constant: 5).isActive = true
        categoryTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()

        self.layoutIfNeeded()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
