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
        addAuthStateChangeListener()
        setupViewControllers()
        showWhatsNew()
        
    }
    
    func setupViewControllers(){
        let mainViewController = MainViewController()
        let appointmentsController = AppointmentsViewController()
        let profileController = ProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        //add search controller in the future
        
        let mainViewNavigationController = UINavigationController(rootViewController: mainViewController)
        let appointmentsNavigationController = UINavigationController(rootViewController: appointmentsController)
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        mainViewNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "homeIconTabBar"))
        appointmentsNavigationController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointmentsIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "appointmentsIconTabBar"))
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profileTabBarIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "profileTabBarIcon"))
        
        if shouldShowAppointmentsController {
            viewControllers = [mainViewNavigationController, appointmentsNavigationController, profileNavigationController]
        } else {
            viewControllers = [mainViewNavigationController, profileNavigationController]
        }
        
        
    }
    
    func addAuthStateChangeListener(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if(auth.currentUser == nil){
                if(self.viewControllers?.count == 3){
                    self.viewControllers?.remove(at: 1)
                }
            } else {
                self.shouldAppointmentController()
            }
        }
    }
    
    func shouldAppointmentController(){
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Services").whereField("creatorID", isEqualTo: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            if documents.count == 0 {
                if(self.viewControllers?.count == 3){
                    self.viewControllers?.remove(at: 1)
                }
            } else {
                if(self.viewControllers?.count == 2){
                    self.showAppointmentsController()
                }
                
            }
        }
    }
    
    func showAppointmentsController(){
        let appointmentsController = AppointmentsViewController()
        let appointmentsNavigationController = UINavigationController(rootViewController: appointmentsController)
        appointmentsNavigationController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointmentsIconTabBar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "appointmentsIconTabBar"))
        self.viewControllers?.insert(appointmentsNavigationController, at: 1)
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
