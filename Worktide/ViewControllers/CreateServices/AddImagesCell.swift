//
//  AddImagesCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-07.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class AddImagesCell:UICollectionViewCell{
    
    public let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    
    func setupView(){
        
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.addDashedBorder()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

