//
//  ServicesCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-14.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ServicesCell:UICollectionViewCell{

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
    
    public let holdForInformation:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hold here"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.isHidden = true
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
        
        featuredServiceJobView.addSubview(bookNow)
        bookNow.trailingAnchor.constraint(equalTo: featuredServiceJobView.trailingAnchor, constant: -15).isActive = true
        bookNow.centerYAnchor.constraint(equalTo: servicePrice.centerYAnchor).isActive = true
        
        //add to last view of featuredServiceJobView
        servicePrice.bottomAnchor.constraint(equalTo: featuredServiceJobView.bottomAnchor, constant:  -25).isActive = true
        
        featuredServiceJobView.addSubview(holdForInformation)
        holdForInformation.leadingAnchor.constraint(equalTo: servicePrice.trailingAnchor, constant: 10).isActive = true
        holdForInformation.trailingAnchor.constraint(equalTo: bookNow.leadingAnchor, constant: -10).isActive = true
        holdForInformation.centerYAnchor.constraint(equalTo: bookNow.centerYAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
