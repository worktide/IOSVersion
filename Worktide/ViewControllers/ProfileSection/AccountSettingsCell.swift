//
//  AccountSettingsCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-02.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class AccountSettingsCell:UICollectionViewCell{
    
    public let backgroundViewColor:UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    public let settingsTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.numberOfLines = 1
        return textView
    }()
    
    public let settingsImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let lineSeperator:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .white
        setupView()
    }
    
    func setupView(){
        
        self.addSubview(backgroundViewColor)
        backgroundViewColor.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundViewColor.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addSubview(lineSeperator)
        lineSeperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        lineSeperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lineSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineSeperator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(settingsImage)
        settingsImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        settingsImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        settingsImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addSubview(settingsTitle)
        settingsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        settingsTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsTitle.trailingAnchor.constraint(equalTo: settingsImage.leadingAnchor, constant: -25).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
