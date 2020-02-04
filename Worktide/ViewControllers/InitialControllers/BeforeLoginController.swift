//
//  BeforeLoginController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-01.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class BeforeLoginController: UIViewController {
    
    private let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let getStartedButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Already have an account? Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup(){
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
        
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        view.addSubview(loginButton)
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(getStartedButton)
        getStartedButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStartedButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -15).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func doneButton(sender: UIButton!) {
        switch sender {
        case getStartedButton:
            let viewController = GetUserLocationController()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case loginButton:
            let viewController = LoginController()
            self.navigationController!.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
   
    
}
