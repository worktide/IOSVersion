//
//  ProfileHeader.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-02.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ProfileHeader:UICollectionReusableView{
    
    var name:String!
    
    public let containerView: UIView = {
          let containerView = UIScrollView()
          containerView.translatesAutoresizingMaskIntoConstraints = false
          containerView.showsHorizontalScrollIndicator = false
          containerView.backgroundColor = .white
          return containerView
      }()
      
      public let mainStackView:UIStackView = {
          let stackView = UIStackView()
          stackView.translatesAutoresizingMaskIntoConstraints = false
          stackView.alignment = .fill
          stackView.axis = .vertical
          stackView.spacing = 25
          stackView.isLayoutMarginsRelativeArrangement = true
          stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
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
      
      
      public let usersNameText: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
          textView.numberOfLines = 1
          return textView
         }()
      
      private let ratingStarImage:UIImageView = {
          let imageView = UIImageView(image: UIImage(named: "starIcon"))
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
         }()
      
      public let ratingStarAmountText: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
          textView.numberOfLines = 1
          return textView
      }()
      
      public let boardView1:UIView = {
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
      
      private let messageIcon: UIImageView = {
          let imageView = UIImageView(image: UIImage(named: "messageIcon"))
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
      
      public let messageBoardText: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
          textView.numberOfLines = 0
          return textView
      }()
      
      private let lineView:UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = .lightGray
          return view
      }()
      
      
      private let tapForMore: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .lightGray
          textView.text = "Tap to learn more"
          textView.textAlignment = NSTextAlignment.left
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
          textView.numberOfLines = 0
          return textView
      }()
      private let whiteContainer1: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.layer.cornerRadius = 8
          view.backgroundColor = .white
          view.layer.cornerRadius = 20.0
          view.layer.shadowColor = UIColor.gray.cgColor
          view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
          view.layer.shadowRadius = 3
          view.layer.shadowOpacity = 0.5
          return view
      }()
      
      public let accountInformationTitle: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.text = "Account Information"
          textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
          textView.numberOfLines = 1
          return textView
      }()
      
      public let usersPhoneNumberText: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.text = "Phone number"
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
          textView.numberOfLines = 1
          return textView
      }()
      
      public let usersPhoneNumber: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
          textView.numberOfLines = 1
          return textView
      }()

      public let accountInfoHiddenText: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .darkGray
          textView.textAlignment = NSTextAlignment.left
          textView.text = "This information is hidden until you have an appointment."
          textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
          textView.numberOfLines = 4
          return textView
      }()
      
      public let accountSettingsTitle: UILabel = {
          let textView = UILabel()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.textColor = .black
          textView.textAlignment = NSTextAlignment.left
          textView.text = "My Services"
          textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
          textView.numberOfLines = 1
          return textView
      }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        
    }
    
    func setupView(){
        
        self.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
              
        containerView.addSubview(userProfileImage)
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(usersNameText)
        usersNameText.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10).isActive = true
        usersNameText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        usersNameText.bottomAnchor.constraint(equalTo: userProfileImage.centerYAnchor, constant: -2).isActive = true
        
        containerView.addSubview(ratingStarImage)
        ratingStarImage.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10).isActive = true
        ratingStarImage.topAnchor.constraint(equalTo: userProfileImage.centerYAnchor, constant: 2).isActive = true
        ratingStarImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        ratingStarImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        containerView.addSubview(ratingStarAmountText)
        ratingStarAmountText.leadingAnchor.constraint(equalTo: ratingStarImage.trailingAnchor, constant: 5).isActive = true
        ratingStarAmountText.centerYAnchor.constraint(equalTo: ratingStarImage.centerYAnchor).isActive = true
        ratingStarAmountText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        //STACK VIEW
        containerView.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 50).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        //MESSAGEBOARD-----------------------------------------------------------------------
        mainStackView.addArrangedSubview(boardView1)
        boardView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        boardView1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true

        
        boardView1.addSubview(messageIcon)
        messageIcon.leadingAnchor.constraint(equalTo: boardView1.leadingAnchor, constant: 10).isActive = true
        messageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        messageIcon.centerYAnchor.constraint(equalTo: boardView1.centerYAnchor).isActive = true
        
        boardView1.addSubview(lineView)
        lineView.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.heightAnchor.constraint(equalTo: boardView1.heightAnchor, multiplier: 0.65).isActive = true
        lineView.leadingAnchor.constraint(equalTo: messageIcon.trailingAnchor, constant: 10).isActive = true
        lineView.centerYAnchor.constraint(equalTo: boardView1.centerYAnchor).isActive = true
        
        boardView1.addSubview(messageBoardText)
        messageBoardText.leadingAnchor.constraint(equalTo: messageIcon.trailingAnchor, constant: 20).isActive = true
        messageBoardText.trailingAnchor.constraint(equalTo: boardView1.trailingAnchor, constant: -10).isActive = true
        messageBoardText.topAnchor.constraint(equalTo: boardView1.topAnchor, constant: 15).isActive = true
        
        boardView1.addSubview(tapForMore)
        tapForMore.leadingAnchor.constraint(equalTo: messageBoardText.leadingAnchor).isActive = true
        tapForMore.topAnchor.constraint(equalTo: messageBoardText.bottomAnchor, constant: 10).isActive = true
        tapForMore.widthAnchor.constraint(equalTo: boardView1.widthAnchor, multiplier: 0.8).isActive = true
        tapForMore.bottomAnchor.constraint(equalTo: boardView1.bottomAnchor, constant: -15).isActive = true

        
        //ACCOUNT INFORMATION------------------------------------------------------------------
        mainStackView.addArrangedSubview(whiteContainer1)
        whiteContainer1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        whiteContainer1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        
        whiteContainer1.addSubview(accountInformationTitle)
        accountInformationTitle.leadingAnchor.constraint(equalTo: whiteContainer1.leadingAnchor, constant: 15).isActive = true
        accountInformationTitle.topAnchor.constraint(equalTo: whiteContainer1.topAnchor, constant: 10).isActive = true
        
        whiteContainer1.addSubview(usersPhoneNumberText)
        usersPhoneNumberText.leadingAnchor.constraint(equalTo: whiteContainer1.leadingAnchor, constant: 15).isActive = true
        usersPhoneNumberText.topAnchor.constraint(equalTo: accountInformationTitle.bottomAnchor, constant: 15).isActive = true
        
        whiteContainer1.addSubview(usersPhoneNumber)
        usersPhoneNumber.trailingAnchor.constraint(equalTo: whiteContainer1.trailingAnchor, constant: -15).isActive = true
        usersPhoneNumber.topAnchor.constraint(equalTo: accountInformationTitle.bottomAnchor, constant: 15).isActive = true
    
        whiteContainer1.addSubview(accountInfoHiddenText)
        accountInfoHiddenText.topAnchor.constraint(equalTo: usersPhoneNumberText.bottomAnchor, constant: 15).isActive = true
        accountInfoHiddenText.leadingAnchor.constraint(equalTo: whiteContainer1.leadingAnchor, constant: 15).isActive = true
        accountInfoHiddenText.trailingAnchor.constraint(equalTo: whiteContainer1.trailingAnchor, constant: -15).isActive = true
        accountInfoHiddenText.bottomAnchor.constraint(equalTo: whiteContainer1.bottomAnchor,constant: -10).isActive = true
        
        //ACCOUNT SETTINGS----------------------------------------------------------------------------
        mainStackView.setCustomSpacing(50, after: whiteContainer1)
        mainStackView.addArrangedSubview(accountSettingsTitle)
        accountSettingsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        accountSettingsTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        //ADD TO LAST VIEW
        accountSettingsTitle.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        

            
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
