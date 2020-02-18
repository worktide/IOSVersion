//
//  UsersNameController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-01.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class UsersNameController: UIViewController{
    
    var shouldShowAppointmentsController = false
    
    public let nameTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let text = "Lets set up your name"
        textView.text = text
        textView.textColor = .black
        textView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
        textView.numberOfLines = 1
        return textView
    }()
    
    public let textField: UITextField = {
        let textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .words
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        textView.textAlignment = .center
        textView.placeholder = "First Last"
        return textView
    }()
    
    public let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Done",for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    let wrongCode:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Minimum of 6 characters"
        textView.textColor = .red
        textView.textAlignment = NSTextAlignment.center
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textView.numberOfLines = 1
        textView.isHidden = true
        return textView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navSetup()
        setupViews()
        
        //Watch keyboard moves
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func navSetup(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    
    }
    
    func setupViews(){
        
        view.addSubview(nameTitle)
        nameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 65).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        view.addSubview(wrongCode)
        wrongCode.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrongCode.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 25).isActive = true
        wrongCode.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
     
        
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
        
        if(textField.text!.count > 6){
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            let ref = Firestore.firestore().collection("Users").document(userID)
            ref.setData(["usersName": textField.text!],merge: true) { err in
                if err != nil {
                    self.showAlert()
                } else {
                    self.shouldAppointmentController()
                }
            }
        } else{
            wrongCode.isHidden = false
        }
        
    }
    
    func shouldAppointmentController(){
        guard let userID = Auth.auth().currentUser?.uid else {
            self.showMainViewController()
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Services").whereField("creatorID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        self.shouldShowAppointmentsController = false
                    } else{
                        self.shouldShowAppointmentsController = true
                    }
                    
                    self.showMainViewController()
                    
                    
                }
        }
    }
    
    func showMainViewController(){
        let tabBarController = TabBarController()
        tabBarController.shouldShowAppointmentsController = shouldShowAppointmentsController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = tabBarController
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: appdelegate.window!, duration: duration, options: options, animations: {}, completion:
        { completed in
        })
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Did not save", message: "Check your internet", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
   
}
