//
//  SelectAppointmentCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-27.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class SelectAppointmentCell:UICollectionViewCell{
    
    public let userProfileImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lightBlueBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let serviceTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public let appointmentDate:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let lineSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(userProfileImage)
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 25).isActive = true
        userProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.addSubview(serviceTitle)
        serviceTitle.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 15).isActive = true
        serviceTitle.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant:  -2).isActive = true
        serviceTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        self.addSubview(appointmentDate)
        appointmentDate.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 15).isActive = true
        appointmentDate.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 2).isActive = true
        appointmentDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        self.addSubview(lineSeperator)
        lineSeperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        lineSeperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        lineSeperator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height / 2.0
        userProfileImage.clipsToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
