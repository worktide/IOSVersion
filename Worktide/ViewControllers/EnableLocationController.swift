//
//  EnableLocationController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-14.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

class EnableLocationController:UIViewController, CLLocationManagerDelegate{
    
    var onDoneBlock : ((Bool) -> Void)?
    
    let locationManager = CLLocationManager()
    var toViewController:String!
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIconBlack"), for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    
    let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigationMarker"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let locationText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let text = "This lets us show you "
        textView.text = text
        textView.textColor = .darkGray
        textView.textAlignment = .center
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        textView.numberOfLines = 4
        return textView
    }()
    
    private let enableLocation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Enable Location", for: .normal)
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
        setupView()
    }
    
    func setupView(){
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(locationText)
        locationText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60).isActive = true
        locationText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        view.addSubview(enableLocation)
        enableLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        enableLocation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        enableLocation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        enableLocation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    @objc func doneButton(sender: UIButton!) {
        
        switch sender {
        case enableLocation:
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        case backButton:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        switch toViewController {
        case "FindJobController":
            ViewControllerStruct.details.pushToViewController = "FindJobController"
            onDoneBlock!(true)
            self.dismiss(animated: true, completion: nil)
        case "JobMapCreatorController":
            ViewControllerStruct.details.pushToViewController = "JobMapCreatorController"
            onDoneBlock!(true)
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController (title: "Allow Location", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}
