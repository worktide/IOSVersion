//
//  ServicePayController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-04.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class ServicePayController:UIViewController{
    
    var delegate: ChangeServiceDelegate?
    
    var costLabelInt = 0
    var fromChangeService = false
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "left_arrow"), for: .normal)
        return button
    }()
    
    private let costLabel: UILabel = {
     let label = UILabel()
     label.translatesAutoresizingMaskIntoConstraints = false
     label.numberOfLines = 1
     label.text = "$0"
     label.textColor = .black
     label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 34)!
     return label
    }()
    
    private let plus1Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+ $1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let plus5Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+ $5", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let plus10Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+ $10", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
       }()
    
    private let plus20Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+ $20", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
       }()
    
    private let plus50Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("+ $50", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
       }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        setupNavigation()
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
        title = "Service Price"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func viewSetup(){
        
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.addTapGestureRecognizer{
            _ = self.navigationController?.popViewController(animated: true)
        }
      
        view.addSubview(costLabel)
        costLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        costLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        costLabel.text = "$" + String(costLabelInt)
        
        view.addSubview(plus20Button)
        plus20Button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        plus20Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        plus20Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(plus50Button)
        plus50Button.leadingAnchor.constraint(equalTo: plus20Button.trailingAnchor, constant: 5).isActive = true
        plus50Button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        plus50Button.widthAnchor.constraint(equalTo: plus20Button.widthAnchor).isActive = true
        plus50Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plus50Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(resetButton)
        resetButton.leadingAnchor.constraint(equalTo: plus50Button.trailingAnchor, constant: 5).isActive = true
        resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        resetButton.widthAnchor.constraint(equalTo: plus20Button.widthAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(plus1Button)
        plus1Button.bottomAnchor.constraint(equalTo: plus20Button.topAnchor, constant: -5).isActive = true
        plus1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        plus1Button.widthAnchor.constraint(equalTo: plus20Button.widthAnchor).isActive = true
        plus1Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(plus5Button)
        plus5Button.leadingAnchor.constraint(equalTo: plus1Button.trailingAnchor, constant: 5).isActive = true
        plus5Button.bottomAnchor.constraint(equalTo: plus20Button.topAnchor, constant: -5).isActive = true
        plus5Button.widthAnchor.constraint(equalTo: plus20Button.widthAnchor).isActive = true
        plus5Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plus5Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(plus10Button)
        plus10Button.leadingAnchor.constraint(equalTo: plus5Button.trailingAnchor, constant: 5).isActive = true
        plus10Button.bottomAnchor.constraint(equalTo: plus20Button.topAnchor, constant: -5).isActive = true
        plus10Button.widthAnchor.constraint(equalTo: plus20Button.widthAnchor).isActive = true
        plus10Button.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    @objc func buttonClicked(sender: UIButton){
        
        let amount = costLabel.text!.components(separatedBy: "$")[1]
        costLabelInt = Int(amount)!
        costLabel.textColor = .black
        
        switch sender {
        
       case plus1Button: // Do something
        costLabel.text = "$" + String(costLabelInt + 1)
       case plus5Button: // Do some other stuff
        costLabel.text = "$" + String(costLabelInt + 5)
       case plus10Button:
        costLabel.text = "$" + String(costLabelInt + 10)
       case plus20Button:
        costLabel.text = "$" + String(costLabelInt + 20)
       case plus50Button:
        costLabel.text = "$" + String(costLabelInt + 50)
       default:
        costLabelInt = 0
        costLabel.text = "$0"
       }
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(self.costLabel.text == "$0"){
                self.costLabel.textColor = .red
            } else {
                if(fromChangeService){
                    let amount = costLabel.text!.components(separatedBy: "$")[1]
                    delegate?.changeServicePay(value: amount)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let viewController = ServiceDurationController()
                    let amount = costLabel.text!.components(separatedBy: "$")[1]
                    InputDetails.details.servicePay = Double(amount)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                    
                
                
                
            }
        default:
            break
        }
    }
    
}

