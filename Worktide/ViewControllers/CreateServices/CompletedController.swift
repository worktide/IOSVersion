//
//  CompletedController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CompletedController:UIViewController{
    
    public let jobUploaded: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let text = "Service Uploaded"
        textView.text = text
        textView.textColor = .black
        textView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
        textView.numberOfLines = 1
        return textView
    }()
    
    public let noNotificationsDisclaimer: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        textView.textAlignment = .center
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let viewJobBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Setup Calendar", for: .normal)
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
        setupViews()
        uploadData()
        getCalendar()
        view.backgroundColor = .white
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    func setupViews(){
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        view.addSubview(jobUploaded)
        jobUploaded.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jobUploaded.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        view.addSubview(noNotificationsDisclaimer)
        noNotificationsDisclaimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noNotificationsDisclaimer.centerYAnchor.constraint(equalTo: jobUploaded.bottomAnchor, constant: 100).isActive = true
        noNotificationsDisclaimer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(viewJobBtn)
        viewJobBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        viewJobBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        viewJobBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewJobBtn.bottomAnchor.constraint(equalTo: doneBtn.topAnchor, constant: -10).isActive = true
        
    }
    
    func uploadData(){
        self.showSpinner(onView: self.view)
        
        let serviceCategory = InputDetails.details.serviceCategory
        let serviceName = InputDetails.details.serviceName
        let latitude = InputDetails.details.latitude
        let longitude = InputDetails.details.longitude
        let circleDistance = InputDetails.details.circleDistance
        let servicePay = InputDetails.details.servicePay
        let serviceDuration = InputDetails.details.serviceDuration
        let serviceDescription = InputDetails.details.serviceDescription
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Services").document().setData([
            "serviceCategory":serviceCategory!,
            "serviceName": serviceName!,
            "latitude": latitude!,
            "longitude": longitude!,
            "circleDistance": circleDistance!,
            "servicePay": servicePay!,
            "serviceDuration": serviceDuration!,
            "serviceDescription": serviceDescription ?? "0",
            "creatorID": userID,
            "timeCreated": Date()
        ]) { err in
            if err != nil {
                self.jobUploaded.text = "Failed to upload"
                self.noNotificationsDisclaimer.text = "Something went wrong, check your internet."
                self.viewJobBtn.setTitle("Retry", for: .normal)
                self.viewJobBtn.isHidden = false
                self.doneBtn.setTitle("Cancel", for: .normal)
            } else {
                self.getCalendar()
        
            }
        }
    }
    
    func getCalendar(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("MySchedule").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        print("No Schedule")
                        self.noNotificationsDisclaimer.text = "Setup your calendar in order for people to book."
                        self.viewJobBtn.isHidden = false
                    } else {
                        self.noNotificationsDisclaimer.text = "Transactions coming soon, please handle your payments for now."
                        self.viewJobBtn.isHidden = true
                    }
                }
            self.removeSpinner()
        }

    }
    
    @objc func doneButton(sender: UIButton!) {
        
        switch sender {
        case doneBtn:
            self.dismiss(animated: true, completion: nil)
            
        case viewJobBtn:
            if(viewJobBtn.titleLabel!.text == "Retry"){
                uploadData()
            } else {
                let viewController = DaysAvailabilityController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overFullScreen
                self.present(navigationController, animated: true)
            }
        default:
            break
        }
        
        
    }
    
    
   
}
