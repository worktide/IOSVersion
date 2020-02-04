//
//  DaysAvailableCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-18.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class DaysAvailableCell:UICollectionViewCell{
    
    
    public let dayOfWeekTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    public let status:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.text = "3 spots available"
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
     public let rightIcon:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIconBlack"), for: .normal)
        button.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .white
        
        self.addSubview(dayOfWeekTitle)
        dayOfWeekTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        dayOfWeekTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        dayOfWeekTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true

        self.addSubview(status)
        status.topAnchor.constraint(equalTo: dayOfWeekTitle.bottomAnchor, constant: 10).isActive = true
        status.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        
        self.addSubview(rightIcon)
        rightIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        rightIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
