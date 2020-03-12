//
//  MyServicesCells.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-02.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class MyServicesCell:UICollectionViewCell{
    
    private let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    public let jobTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    public let servicePrice:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        return label
    }()
    
    public let statusText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status:"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    public let status:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not Approved"
        label.textColor = .systemRed
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerLayout.layer.cornerRadius = 15
    }
    
    func setupView(){
        
        self.addSubview(containerLayout)
        containerLayout.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        containerLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        containerLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        containerLayout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        //containerLayout.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerLayout.addSubview(servicePrice)
        servicePrice.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        servicePrice.centerYAnchor.constraint(equalTo: containerLayout.centerYAnchor).isActive = true
    
        containerLayout.addSubview(jobTitle)
        jobTitle.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        jobTitle.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 20).isActive = true
        jobTitle.trailingAnchor.constraint(equalTo: servicePrice.leadingAnchor, constant: -25).isActive = true
        
        containerLayout.addSubview(statusText)
        statusText.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        statusText.topAnchor.constraint(equalTo: jobTitle.bottomAnchor, constant: 5).isActive = true
        
        containerLayout.addSubview(status)
        status.leadingAnchor.constraint(equalTo: statusText.trailingAnchor, constant: 3).isActive = true
        status.centerYAnchor.constraint(equalTo: statusText.centerYAnchor).isActive = true
        
        
        status.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor, constant: -20).isActive = true
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
