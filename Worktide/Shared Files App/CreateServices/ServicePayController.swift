//
//  ServicePayController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-04.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class ServicePayController:UIViewController, UITextFieldDelegate{
    
    var createServiceModel:CreateServiceModel!
    var rightBarItem: UIBarButtonItem!
    
    //Item Initialization-------------------------------------------------------
    
    private let basePriceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Base Price"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let priceDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How much are you charging for your serivce?"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let currencyLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CA $"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let priceTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.left
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.setLeftRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let minimumPriceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Minimum Price"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let minimumPriceDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let the customers know how low you are able to price your service based on the difficulty."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let minimumCurrencyLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CA $"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let minimumPriceTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.left
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.setLeftRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    private let maximumPriceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Maximum Price"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let maximumPriceDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let the customer know the highest price your service can charge them for."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let maximumCurrencyLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CA $"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let maximumPriceTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.left
        textField.setLeftRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    private let errorMessage:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "maximum price has to be lower than minimum price"
        label.textColor = .systemRed
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    //IOS FUNCTIONS-------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        
        switch createServiceModel.variedPricing {
        case true:
            variedPricingView()
        default:
            basePricingView()
        }
    }
    
    
    //ViewsSetup-------------------------------------------------------
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        rightBarItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = "Pricing"
        
    }
    
    func variedPricingView(){
        ///ScrollView----------------------------------------
        view.addSubview(scrollView)
        scrollView.addSubview(minimumPriceLabel)
        scrollView.addSubview(minimumPriceDescription)
        scrollView.addSubview(minimumCurrencyLabel)
        scrollView.addSubview(minimumPriceTextField)
        
        scrollView.addSubview(maximumPriceLabel)
        scrollView.addSubview(maximumPriceDescription)
        scrollView.addSubview(maximumCurrencyLabel)
        scrollView.addSubview(maximumPriceTextField)
        scrollView.addSubview(errorMessage)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        ///Minimums----------------------------------------
        
        minimumPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        minimumPriceLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        minimumPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        minimumPriceDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        minimumPriceDescription.topAnchor.constraint(equalTo: minimumPriceLabel.bottomAnchor, constant: 10).isActive = true
        minimumPriceDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        minimumCurrencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        minimumCurrencyLabel.topAnchor.constraint(equalTo: minimumPriceDescription.bottomAnchor, constant: 35).isActive = true
        
        minimumPriceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        minimumPriceTextField.leadingAnchor.constraint(equalTo: minimumCurrencyLabel.trailingAnchor, constant: 15).isActive = true
        minimumPriceTextField.centerYAnchor.constraint(equalTo: minimumCurrencyLabel.centerYAnchor).isActive = true
        minimumPriceTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        ///Maximums----------------------------------------
        
        maximumPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        maximumPriceLabel.topAnchor.constraint(equalTo: minimumPriceTextField.bottomAnchor, constant: 60).isActive = true
        maximumPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        maximumPriceDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        maximumPriceDescription.topAnchor.constraint(equalTo: maximumPriceLabel.bottomAnchor, constant: 10).isActive = true
        maximumPriceDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        maximumCurrencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        maximumCurrencyLabel.topAnchor.constraint(equalTo: maximumPriceDescription.bottomAnchor, constant: 35).isActive = true
        
        maximumPriceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maximumPriceTextField.leadingAnchor.constraint(equalTo: maximumCurrencyLabel.trailingAnchor, constant: 15).isActive = true
        maximumPriceTextField.centerYAnchor.constraint(equalTo: maximumCurrencyLabel.centerYAnchor).isActive = true
        maximumPriceTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //add to last view
        
        errorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        errorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        errorMessage.topAnchor.constraint(equalTo: maximumPriceTextField.bottomAnchor, constant: 25).isActive = true
        
        errorMessage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true

        //textFieldDelgeate---
        priceTextField.delegate = self
        minimumPriceTextField.delegate = self
        maximumPriceTextField.delegate = self
        
        
    }
    
    func basePricingView(){
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(basePriceLabel)
        scrollView.addSubview(priceDescription)
        scrollView.addSubview(currencyLabel)
        scrollView.addSubview(priceTextField)
        
        basePriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        basePriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        basePriceLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        
        priceDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        priceDescription.topAnchor.constraint(equalTo: basePriceLabel.bottomAnchor, constant: 10).isActive = true
        priceDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        currencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        currencyLabel.topAnchor.constraint(equalTo: priceDescription.bottomAnchor, constant: 35).isActive = true
        
        priceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        priceTextField.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 15).isActive = true
        priceTextField.centerYAnchor.constraint(equalTo: currencyLabel.centerYAnchor).isActive = true
        priceTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    //TextField--------------------------------------------------------
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        errorMessage.isHidden = true
        if isTextFieldComplete() {
            self.navigationItem.rightBarButtonItem = rightBarItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    //Button Listeners-------------------------------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if isTextFieldComplete(){
                
                if createServiceModel.variedPricing! {
                    
                    let minimumPrice = minimumPriceTextField.text?.toDouble() ?? 0
                    let maximumPrice = maximumPriceTextField.text?.toDouble() ?? 1
                    
                    if(minimumPrice.isLess(than: maximumPrice)){
                        createServiceModel.minimumPrice = minimumPrice
                        createServiceModel.maximumPrice = maximumPrice
                        self.showServiceLocation()
                    } else {
                        self.errorMessage.isHidden = false
                    }
                } else {
                    let basePrice = priceTextField.text?.toDouble()
                    createServiceModel.basePrice = basePrice
                    self.showServiceLocation()
                }
                
            }
        default:
            break
        }
    }
    
    //Do Functions-------------------------------------------------------
    
    func showServiceLocation(){
        let viewController = ServiceLocation()
        viewController.createServiceModel = createServiceModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func isTextFieldComplete() -> Bool{
        switch createServiceModel.variedPricing {
        case true:
            if(!maximumPriceTextField.isEmpty && !minimumPriceTextField.isEmpty){
                return true
            } else {
                return false
            }
        default:
            if(!priceTextField.isEmpty){
                return true
            } else {
                return false
            }
        }
    }
    
    
}

