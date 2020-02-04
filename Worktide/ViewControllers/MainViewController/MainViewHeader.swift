//
//  MainViewHeader.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-23.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class MainViewHeader:  UITableViewHeaderFooterView {
    public let mainStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    public let messageBoardText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        textView.numberOfLines = 0
        return textView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        setupView()
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
    }
    
    func setupView(){
        self.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        mainStackView.addArrangedSubview(messageBoardText)
        messageBoardText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        messageBoardText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        messageBoardText.topAnchor.constraint(equalTo: mainStackView.topAnchor).isActive = true
        messageBoardText.bottomAnchor.constraint(equalTo:mainStackView.bottomAnchor).isActive = true
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

