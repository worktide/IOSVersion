//
//  SupportController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class SupportController:UIViewController{
    
    private let phoneNumberText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.text = "You can reach us at\nworktide@outlook.com"
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        textView.numberOfLines = 0
        textView.textAlignment = .center
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupView()
    }
    
    func setupView(){
        view.addSubview(phoneNumberText)
        phoneNumberText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        phoneNumberText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        phoneNumberText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }
    
    func setupNavigationBar(){
        self.navigationItem.title = "Support"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
      
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
