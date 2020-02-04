//
//  PeopleListCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-30.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class PeopleListCell:UICollectionViewCell{
    
    
    public let userProfileImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lightBlueBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(userProfileImage)
        userProfileImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        userProfileImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()

        self.userProfileImage.layoutIfNeeded()      
        self.userProfileImage.layer.cornerRadius = frame.size.width/2
        self.userProfileImage.clipsToBounds = true
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
