//
//  VerifyPhoneNumberController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-30.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class VerifyPhoneNumberController:UIViewController{
    
    var keyboardHeight:CGFloat = 0
    var shouldDismissController = false
    
    private let phoneNumberText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.text = "WE SENT A CODE TO"
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    public let phoneNumberShow: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let phoneNumberField: UITextField! = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "000000"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.center
        return textField
    }()
    
    public let wrongCode: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemRed
        textView.textAlignment = NSTextAlignment.center
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        textView.numberOfLines = 0
        textView.text = "Wrong Code"
        textView.isHidden = true
        return textView
    }()
    
    public let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Verify",for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIImageView = {
        let tintedImage = UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysTemplate)
        let button = UIImageView(image: tintedImage)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(phoneNumberText)
        phoneNumberText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        view.addSubview(phoneNumberShow)
        phoneNumberShow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberShow.topAnchor.constraint(equalTo: phoneNumberText.bottomAnchor, constant: 25).isActive = true
        
        view.addSubview(phoneNumberField)
        phoneNumberField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberField.topAnchor.constraint(equalTo: phoneNumberShow.bottomAnchor, constant: 25).isActive = true
        phoneNumberField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        phoneNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        phoneNumberField.keyboardType = .numberPad
        phoneNumberField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        view.addSubview(wrongCode)
        wrongCode.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrongCode.topAnchor.constraint(equalTo: phoneNumberField.bottomAnchor, constant: 25).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            wrongCode.isHidden = true
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
                self.view.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height - keyboardSize.height)
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func doneButton(sender: UIButton!) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "Verifying", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        checkCode()
    }
    
    func checkCode(){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        
        let verificationCode = phoneNumberField.text!
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                self.dismiss(animated: true, completion: {
                    self.wrongCode.isHidden = false
                })
                return
            }
            self.dismiss(animated: true, completion: {
                self.isUserProfileCompelte()
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("Users").document(userID).setData([
                    "usersPhoneNumber": self.phoneNumberShow.text ?? "Set your phone number"
                ], merge: true)
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
    
    
    func isUserProfileCompelte(){
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let usersName = document.get("usersName")
                if(usersName == nil){
                    self.showNameController()
                } else {
                    self.showMainViewController()
                }
            } else {
                self.showNameController()
            }
        }
    }
    
    func showMainViewController(){
        let tabBarController = TabBarController()
        
        if(shouldDismissController){
            self.dismiss(animated: true, completion: nil)
        } else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = tabBarController
            
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: appdelegate.window!, duration: duration, options: options, animations: {}, completion:
            { completed in
            })
        }
        
        
    }
    
    func showNameController(){
        let viewController = UsersNameController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    
}
