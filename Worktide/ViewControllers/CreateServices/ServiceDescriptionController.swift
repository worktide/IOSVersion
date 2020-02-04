//
//  ServiceDescriptionController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-04.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class ServiceDescriptionController:UIViewController, UITextViewDelegate{
    
    var delegate: ChangeServiceDelegate?
    var fromChangeService = false
    
    var serviceDescription = "0"
    
    private let textView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.becomeFirstResponder()
        textView.textColor = .black
        return textView
    }()
    
    private let placeHolder:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Describe what you are offering, or what they will get."
        label.isUserInteractionEnabled = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
        title = "Service Description"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        textView.delegate = self
        
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(placeHolder)
        placeHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        placeHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        placeHolder.topAnchor.constraint(equalTo: view.topAnchor, constant: 208).isActive = true
        
        
        if(serviceDescription != "0" || serviceDescription.count == 0){
            textView.text = serviceDescription
            placeHolder.isHidden = true
        } else {
            placeHolder.isHidden = false
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //300 chars restriction
        return textView.text.count + (text.count - range.length) <= 100
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count == 0){
            placeHolder.isHidden = false
        } else {
            placeHolder.isHidden = true
        }
    }
    
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(fromChangeService){
                if(textView.text.count != 0){
                    delegate?.changeServiceDescription(value: textView.text)
                }
                self.dismiss(animated: true, completion: nil)
                
            } else {
                let viewController = CompletedController()
                InputDetails.details.serviceDescription = textView.text
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        default:
            break
        }
    }
    
    
}
