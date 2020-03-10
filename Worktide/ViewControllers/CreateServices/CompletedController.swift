//
//  CompletedController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CompletedController:UIViewController{
    
    public let titleLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let text = "Sent for Review"
        textView.text = text
        textView.textColor = .black
        textView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
        textView.numberOfLines = 1
        return textView
    }()
    
    public let descriptionLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        textView.textAlignment = .center
        textView.text = "Your service has been sent for review, this typically takes 2-3 business days. Feel free to make changes before it has been reviewed.\n\nLearn more about our reviewing system."
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let learnMoreButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Learn More"
        label.textColor = .systemBlue
        return label
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds =  false
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        view.backgroundColor = .white
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    func setupViews(){
        view.backgroundColor = .white
        
        
        view.addSubview(doneBtn)
        view.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        learnMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        learnMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        learnMoreButton.addTapGestureRecognizer{
            HelperViewTransitions.showWebPageURL(urlString: "https://1drv.ms/w/s!AhGn6NyXqX0ra3jIVF2gBxHXDDA?e=3dmXya", viewController: self)
        }
        
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    @objc func doneButton(sender: UIButton!) {
        
        switch sender {
        case doneBtn:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        
    }
    
    
   
}
