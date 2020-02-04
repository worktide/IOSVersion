//
//  ServiceDetailsCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-21.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ServiceDetailsCell:UICollectionViewCell{
    
    public let userProfileImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lightBlueBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let featuredServiceJobView:UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = .white
          view.layer.cornerRadius = 20.0
          view.layer.shadowColor = UIColor.gray.cgColor
          view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
          view.layer.shadowRadius = 3
          view.layer.shadowOpacity = 0.5
          return view
      }()
      
    public let serviceTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Men's Haircut"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
      }()
      
      public let serviceDistance:UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "15km away from you"
          label.numberOfLines = 0
          label.textColor = .darkGray
          label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
          label.textAlignment = .left
          return label
      }()
      
      public let servicePrice:UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "$40"
          label.numberOfLines = 0
          label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
          label.textColor = .systemGreen
          label.textAlignment = .left
          return label
      }()
      
      public let serviceDuration:UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "45 mins"
          label.numberOfLines = 0
          label.textColor = .darkGray
          label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
          label.textAlignment = .left
          return label
      }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupView()
        
    }
    
    func setupView(){
        
        self.addSubview(featuredServiceJobView)
        featuredServiceJobView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        featuredServiceJobView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        featuredServiceJobView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        featuredServiceJobView.addSubview(serviceDuration)
        serviceDuration.trailingAnchor.constraint(equalTo: featuredServiceJobView.trailingAnchor, constant: -15).isActive = true
        serviceDuration.topAnchor.constraint(equalTo: featuredServiceJobView.topAnchor, constant: 25).isActive = true
        
        featuredServiceJobView.addSubview(serviceTitle)
        serviceTitle.leadingAnchor.constraint(equalTo: featuredServiceJobView.leadingAnchor, constant: 15).isActive = true
        serviceTitle.topAnchor.constraint(equalTo: featuredServiceJobView.topAnchor, constant: 25).isActive = true
        serviceTitle.trailingAnchor.constraint(equalTo: serviceDuration.leadingAnchor, constant: -10).isActive = true
        
        featuredServiceJobView.addSubview(serviceDistance)
        serviceDistance.leadingAnchor.constraint(equalTo: featuredServiceJobView.leadingAnchor, constant: 15).isActive = true
        serviceDistance.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 5).isActive = true
        
        featuredServiceJobView.addSubview(servicePrice)
        servicePrice.leadingAnchor.constraint(equalTo: featuredServiceJobView.leadingAnchor, constant: 15).isActive = true
        servicePrice.topAnchor.constraint(equalTo: serviceDistance.bottomAnchor, constant: 20).isActive = true
        
        featuredServiceJobView.addSubview(userProfileImage)
        userProfileImage.trailingAnchor.constraint(equalTo: featuredServiceJobView.trailingAnchor, constant: -10).isActive = true
        userProfileImage.bottomAnchor.constraint(equalTo: featuredServiceJobView.bottomAnchor, constant: -25).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add to last view of featuredServiceJobView
        servicePrice.bottomAnchor.constraint(equalTo: featuredServiceJobView.bottomAnchor, constant:  -25).isActive = true
        
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
