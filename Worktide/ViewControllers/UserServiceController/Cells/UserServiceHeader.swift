//
//  UserServiceHeader.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-13.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import HCSStarRatingView

class UserSerivceHeader: UICollectionReusableView {
    
    var name:String!
    
    public let mainStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    public let userProfileImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lightBlueBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let ratingStar:HCSStarRatingView = {
        let ratingStar = HCSStarRatingView()
        ratingStar.allowsHalfStars = true
        ratingStar.accurateHalfStars = true
        ratingStar.value = 0
        ratingStar.minimumValue = 1
        ratingStar.maximumValue = 5
        ratingStar.backgroundColor = .clear
        ratingStar.isUserInteractionEnabled = false
        return ratingStar
    }()
    
    public let ratingAmount:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not enough ratings"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        label.textAlignment = .center
        return label
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
    
    public let bookNow: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemBlue
        textView.text = "Book now >"
        textView.textAlignment = NSTextAlignment.right
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        textView.numberOfLines = 1
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    }
    
    func setupView(){
        
        self.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        mainStackView.addArrangedSubview(userProfileImage)
        userProfileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        mainStackView.addArrangedSubview(ratingStar)
        mainStackView.setCustomSpacing(10, after: userProfileImage)
        ratingStar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        mainStackView.addArrangedSubview(ratingAmount)
        mainStackView.setCustomSpacing(10, after: ratingStar)

        //add to last view
        ratingAmount.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -25).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height / 2.0
        userProfileImage.clipsToBounds = true
        
        if(name != nil){
            let fullNameArr = name.components(separatedBy: " ")
            if(fullNameArr.count == 1){
                userProfileImage.addInitials(first: fullNameArr[0].first!.description, second: "", textSize: 30)
            } else if (fullNameArr.count > 1){
                userProfileImage.addInitials(first: fullNameArr[0].first!.description, second: fullNameArr[1].first!.description, textSize: 30)
            }
        } 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


