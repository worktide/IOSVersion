//
//  ViewAppointmentCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-26.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ViewAppointmentCell:UITableViewCell{
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()
    
    public let title: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemBlue
        textView.text = "View Appointments"
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 1
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        self.addSubview(background)
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(title)
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()

        self.layoutIfNeeded()
        background.layer.cornerRadius = 10
        background.clipsToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
