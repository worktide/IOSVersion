//
//  TimeAvailabilityCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-18.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class TimeAvailabilityCell:UICollectionViewCell{
    
    private let container:UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public let timeLabel:UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.textColor = .systemBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        contentView.addSubview(container)
        container.widthAnchor.constraint(equalToConstant: 100).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        container.addSubview(timeLabel)
        timeLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
