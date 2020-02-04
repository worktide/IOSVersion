//
//  LoginController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-29.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import Foundation
import SafariServices
import FirebaseAuth

class LoginController:UIViewController{
    
    var dismissViewController = false
    
    private let backButton: UIImageView = {
        let tintedImage = UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysTemplate)
        let button = UIImageView(image: tintedImage)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let phoneNumberText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.text = "VERIFY PHONE NUMBER"
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let phoneNumberField: UITextField! = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "+1 000-000-0000"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.center
        return textField
    }()
    
    public let termsText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "By signing in you agree to our Terms of Service and Privacy Policy"
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        textView.numberOfLines = 0
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    public let availableText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Made in Canada\nAvailable in United States, Canada"
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.center
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        textView.numberOfLines = 0
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupView()
    }
    
    func setupView(){
        setGradientBackground()
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.addTapGestureRecognizer{
            if(self.dismissViewController == true){
                self.dismiss(animated: true, completion: nil)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(phoneNumberText)
        phoneNumberText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        view.addSubview(phoneNumberField)
        phoneNumberField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberField.topAnchor.constraint(equalTo: phoneNumberText.bottomAnchor, constant: 25).isActive = true
        phoneNumberField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        phoneNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        

        phoneNumberField.keyboardType = .numberPad
        phoneNumberField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        view.addSubview(termsText)
        termsText.leadingAnchor.constraint(equalTo: phoneNumberField.leadingAnchor).isActive = true
        termsText.trailingAnchor.constraint(equalTo: phoneNumberField.trailingAnchor).isActive = true
        termsText.topAnchor.constraint(equalTo: phoneNumberField.bottomAnchor, constant: 50).isActive = true
        
        view.addSubview(availableText)
        availableText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        availableText.trailingAnchor.constraint(equalTo: phoneNumberField.trailingAnchor).isActive = true
        availableText.leadingAnchor.constraint(equalTo: phoneNumberField.leadingAnchor).isActive = true
        
        let stringValue = "By signing in you agree to our Terms of Service and Privacy Policy"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "Terms of Service", withColor: UIColor.green)
        attributedString.setColorForText(textForAttribute: "Privacy Policy", withColor: UIColor.green)
        termsText.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        termsText.addGestureRecognizer(tap)
    
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let url = URL(string: "https://docs.google.com/document/d/1AGShVBQ_uwXWF85InnLMPxwzmhKT8F4LoCKW7QEBgA4/edit?usp=sharing")
        let svc = SFSafariViewController(url: url!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = phoneNumberField.text else { return }
        phoneNumberField.text = text.applyPatternOnNumbers(pattern: "+# ###-###-####", replacmentCharacter: "#")
        
        if ((phoneNumberField.text!.count) == 15) {
            view.endEditing(true)
            loadingToSendCode()
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.layoutIfNeeded() // force any pending operations to finish
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            view.layoutIfNeeded() // force any pending operations to finish
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height)
                self.view.layoutIfNeeded()
            })
            
        
        }
    }
    
    
    func setGradientBackground() {
        let colorBottom =  UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 0/255.0, green: 132/255.0, blue: 227/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func loadingToSendCode(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        authenticationSetUp()
    }
    
    func authenticationSetUp(){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberField.text!, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
                    self.showAlert()
                }
                return
            }
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
                let viewController = VerifyPhoneNumberController()
                viewController.phoneNumberShow.text = self.phoneNumberField.text!
                viewController.shouldDismissController = self.dismissViewController
                self.navigationController!.pushViewController(viewController, animated: true)
               // Sign in using the verificationID and the code sent to the user
            }
        
            
        
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Too many attempts try later", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
}
