//
//  WhatsNewViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-04.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

class WhatsNewViewController: UIViewController{
    
    private let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "priceIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Service Description"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let newDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let customers know what they get for your services, navigate to the service in your profile to add the description."
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imageView1:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imageIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newTitle1:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Service Images"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let newDescription1:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Show off your work, and add images to your services."
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imageView2:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "linkIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newTitle2:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile Link"
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let newDescription2:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Share your services and let people book with you through Worktide."
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds =  false
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
        checkForLocationPermission()
        
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "What's New"
        
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 190).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(newTitle)
        newTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        newTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        view.addSubview(newDescription)
        newDescription.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        newDescription.topAnchor.constraint(equalTo: newTitle.bottomAnchor, constant: 5).isActive = true
        //-----------------------------------------------
        
        view.addSubview(imageView1)
        imageView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        imageView1.topAnchor.constraint(equalTo: newDescription.bottomAnchor, constant: 35).isActive = true
        imageView1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(newTitle1)
        newTitle1.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newTitle1.topAnchor.constraint(equalTo: newDescription.bottomAnchor, constant: 25).isActive = true
        newTitle1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        view.addSubview(newDescription1)
        newDescription1.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newDescription1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        newDescription1.topAnchor.constraint(equalTo: newTitle1.bottomAnchor, constant: 5).isActive = true
        
        //-----------------------------------------------
        view.addSubview(imageView2)
        imageView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        imageView2.topAnchor.constraint(equalTo: newDescription1.bottomAnchor, constant: 35).isActive = true
        imageView2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(newTitle2)
        newTitle2.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newTitle2.topAnchor.constraint(equalTo: newDescription1.bottomAnchor, constant: 25).isActive = true
        newTitle2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        view.addSubview(newDescription2)
        newDescription2.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15).isActive = true
        newDescription2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        newDescription2.topAnchor.constraint(equalTo: newTitle2.bottomAnchor, constant: 5).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func doneButton(sender: UIButton!) {
        
        switch sender {
        case doneBtn:
            self.dismiss(animated: true, completion: {
                self.registerForRemoteNotification()
            })
        
        default:
            break
        }
        
        
    }
    
    func checkForLocationPermission(){
       if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
           case .notDetermined, .restricted, .denied:
                self.openEnableLocationController()
           case .authorizedAlways, .authorizedWhenInUse:
                break
           @unknown default:
               self.openEnableLocationController()
           }
       } else {
           self.openEnableLocationController()
       }
   }
    
    func openEnableLocationController(){
        let viewController = EnableLocationController()
        viewController.locationText.text = "Just in case your address doesn't match your location. Let us remind you."
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }
    
    func registerForRemoteNotification() {

        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async(execute: {
                      UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
         

        }else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    
}
