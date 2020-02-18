//
//  ProfileImageSetupViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-17.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class ProfileImageSetupViewController: UIViewController {
    
    private let Albert: UIImageView = {
        let image = UIImageView(image: UIImage(named: "defaultProfileImage"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = ""
        text.textColor = .black
        return text
    }()
    
    private let skipbutton: UIButton = {
        let skipbutton = UIButton()
        skipbutton.translatesAutoresizingMaskIntoConstraints = false
        skipbutton.setTitle("Skip", for: .normal)
        skipbutton.setTitleColor(.darkGray, for: .normal)
        return skipbutton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       setuoView()
        
        
    }
    
    func setuoView(){
        view.backgroundColor = .white
               
        view.addSubview(Albert)
        Albert.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Albert.heightAnchor.constraint(equalToConstant: 160).isActive = true
        Albert.widthAnchor.constraint(equalToConstant: 160).isActive = true
        Albert.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        view.addSubview(text)
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(skipbutton)
        skipbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        
    }
        

}
