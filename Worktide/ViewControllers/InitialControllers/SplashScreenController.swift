//
//  SplashScreen.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-29.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class SplashScreenController: UIViewController, CLLocationManagerDelegate {
    
    let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Copyright © 2019 Kristofer Huang. All rights reserved."
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 9.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //signout if first time downloaded
        if(!UserDefaults.standard.bool(forKey: "isFirstDownload")){
            do {
                try Auth.auth().signOut()
                } catch let err {
                    print(err)
            }
            UserDefaults.standard.set(true, forKey: "isFirstDownload") //Bool
        }
        
        viewSetup()
        isUserLoggedIn()
        
    }
    
    
    func viewSetup(){
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
        
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        view.addSubview(label)
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func isUserLoggedIn(){
        if Auth.auth().currentUser != nil {
            isUserProfileCompelte()
        } else {
            if (UserDefaults.standard.string(forKey: "usersAddress") == nil){
                self.showLoginScreen()
            } else {
                self.showMainViewController()
            }
        }
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
    
    func showNameController(){
        let viewController = UsersNameController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }

    func showMainViewController(){
        let tabBarController = TabBarController()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = tabBarController
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: appdelegate.window!, duration: duration, options: options, animations: {}, completion:
        { completed in
        })
    }
    
    func showLoginScreen(){
        let viewController = BeforeLoginController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
 
    
    
}

