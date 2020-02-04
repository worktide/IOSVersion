//
//  TabBarController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

class TabBarController:UITabBarController{
    
    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        showWhatsNew()
        
    }
    
    func setupViewControllers(){
        let mainViewController = MainViewController()
        let appointmentsController = AppointmentsViewController(collectionViewLayout:UICollectionViewFlowLayout())
        let profileController = ProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        //add search controller in the future
        
        let mainViewNavigationController = UINavigationController(rootViewController: mainViewController)
        let appointmentsNavigationController = UINavigationController(rootViewController: appointmentsController)
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        mainViewNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "homeIconTabBar"))
        appointmentsNavigationController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointmentsIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "appointmentsIconTabBar"))
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profileTabBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "profileTabBarIcon"))
        
        viewControllers = [mainViewNavigationController, appointmentsNavigationController, profileNavigationController]
        
    }
    
    func showWhatsNew(){
        
        if(UserDefaults.standard.string(forKey: "WhatsNew") != "YHZMsXkH0qVu7Z"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let viewController = WhatsNewViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true)
                //UserDefaults.standard.set("YHZMsXkH0qVu7Z", forKey: "WhatsNew")
            }
        }
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
    
    func openEnableLocationController(){
        let viewController = EnableLocationController()
        viewController.backButton.isHidden = true
        viewController.locationText.text = "We need your location to ensure the services you see are in your area."
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }
    
}
