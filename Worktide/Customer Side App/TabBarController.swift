//
//  TabBarController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class TabBarController:UITabBarController{
    
    //let locationManager = CLLocationManager()
    
    var shouldShowAppointmentsController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        requiredViewCheck()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkViewsAgain(_:)), name: NSNotification.Name(rawValue: "showViewsListener"), object: nil)
    }
    
    func setupViewControllers(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 10)!], for: .selected)
        
        let mainViewController = MainViewController()
        let notificationController = NotificationsController()
        let profileController = ProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        
        let mainViewNavigationController = UINavigationController(rootViewController: mainViewController)
        let notificationNavigationController = UINavigationController(rootViewController: notificationController)
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        let mainViewTabBarItem = UITabBarItem(title:"Home", image: UIImage(named: "homeIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "homeIconTabBar"))
        
        let notificationTabBarItem = UITabBarItem(title: "Bookings", image: UIImage(named: "notificationTabBarcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "notificationTabBarcon"))
        
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profileTabBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "profileTabBarIcon"))
        
        mainViewNavigationController.tabBarItem = mainViewTabBarItem
        notificationNavigationController.tabBarItem = notificationTabBarItem
        profileNavigationController.tabBarItem = profileTabBarItem
        
        viewControllers = [mainViewNavigationController, notificationNavigationController,profileNavigationController]
        
    }
    
    
    
    func requiredViewCheck(){
        
        if(UserDefaults.standard.string(forKey: "WhatsNew") != "YHZMsXkH0qVu7Z"){
            showWhatsNew()
        } else if !checkIfWeCanSeeLocation() || (UserDefaults.standard.bool(forKey: "AskLocationPermission") != false){
            showEnableLocationController()
        }
    }
    
    func showWhatsNew(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let viewController = WhatsNewViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            
            self.present(navigationController, animated: true)
            //UserDefaults.standard.set("YHZMsXkH0qVu7Z", forKey: "WhatsNew")
        }
    }
    
    func showEnableLocationController(){
        //show enable location
        let viewController = EnableLocationController()
        viewController.backButton.isHidden = true
        viewController.locationText.text = "We need your location to ensure the services you see are in your area."
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }
    
    @objc func checkViewsAgain(_ notification: NSNotification) {
           requiredViewCheck()
    }
    
    func checkIfWeCanSeeLocation() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
         switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
    
    

    
}
