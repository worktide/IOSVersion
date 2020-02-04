//
//  SectionTitleHeader.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-24.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class SectionTitleHeader:UITableViewHeaderFooterView{
    
    public let title: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()
    
    public let seeAll: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemBlue
        textView.text = "See all >"
        textView.textAlignment = NSTextAlignment.right
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        textView.numberOfLines = 1
        textView.isHidden = true
        return textView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        self.addSubview(seeAll)
        seeAll.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        seeAll.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 35).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        title.trailingAnchor.constraint(equalTo: seeAll.leadingAnchor, constant:  -10).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
           
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
