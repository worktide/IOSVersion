//
//  ServicesByCategoryController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-21.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import MapKit
import UIKit
import FirebaseFirestore
import FirebaseStorage

class ServicesByCategoryController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var serviceCategory:String!
    var location:CLLocationCoordinate2D!
    var array = [ServiceCategoryModel]()
    
    var reloadOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.title = serviceCategory
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        
        getData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(!reloadOnce){
            reloadOnce = true
            self.updateCollectionView()
        }
    }
    
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 25, left: 0, bottom: 80, right: 0)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.delegate = self
        collectionView.register(ServiceDetailsCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ServiceDetailsCell
        let model = array[indexPath.row]
        cell.serviceTitle.text = model.serviceTitle
        cell.servicePrice.text = model.servicePay
        cell.serviceDuration.text = model.duration
        cell.serviceDistance.text = model.locationDistance
        
        switch model.creatorImage {
        case nil:
            cell.userProfileImage.removeAllSubviews()
            cell.userProfileImage.image = UIImage(named: "lightBlueBackground")
            let fullNameArr = model.creatorName!.components(separatedBy: " ")
            if(fullNameArr.count == 1){
                cell.userProfileImage.addInitials(first: fullNameArr[0].first!.description, second: "", textSize: 20)
            } else if(fullNameArr.count <= 2){
                cell.userProfileImage.addInitials(first: fullNameArr[0].first!.description, second: fullNameArr[1].first!.description, textSize: 20)
            }
        default:
            cell.userProfileImage.removeAllSubviews()
            cell.userProfileImage.image = model.creatorImage
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ServiceDetailsCell
        
        let viewController = UserServiceController(collectionViewLayout: UICollectionViewFlowLayout())
        let model = array[indexPath.row]
        viewController.userID = model.creatorID!
        viewController.title = model.creatorName
        if(model.creatorImage == nil){
            viewController.usersPhoto = UIImage()
        } else {
            viewController.usersPhoto = cell.userProfileImage.image
        }
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 150)
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            _ = navigationController?.popViewController(animated: true)
            
        default:
            break
        }
    }
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("Services").whereField("serviceCategory", isEqualTo: serviceCategory!).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let serviceName = document.get("serviceName") as! String
                        let servicePay = document.get("servicePay") as! Int
                        let serviceID = document.documentID
                        let latitude = document.get("latitude") as! Double
                        let longitude = document.get("longitude") as! Double
                        let circleRadius = document.get("circleDistance") as! Double
                        let serviceDuration = document.get("serviceDuration") as! Int
                        let creatorID = document.get("creatorID") as! String
                        
                        var creatorImage:UIImage!
                        
                        //get user image
                        let db = Firestore.firestore()
                        db.collection("Users").document(creatorID).getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                let creatorName = document.get("usersName") as? String
                                let photoURL = document.get("userPhotoURL") as? String ?? "0"
                                if(photoURL != "0"){
                                    let storageRef = Storage.storage().reference(forURL: photoURL)
                                    storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                                        if error != nil {
                                            creatorImage = nil

                                            self.array.append(ServiceCategoryModel(serviceTitle: serviceName, servicePay: String(servicePay), serviceID: serviceID, latitude: latitude, longitude: longitude, circleRadius: circleRadius, currentLocation: self.location, duration: serviceDuration, creatorImage: creatorImage, creatorName: creatorName, creatorID: creatorID))

                                            self.updateCollectionView()
                                        } else {
                                            creatorImage = UIImage(data: data!)!

                                            self.array.append(ServiceCategoryModel(serviceTitle: serviceName, servicePay: String(servicePay), serviceID: serviceID, latitude: latitude, longitude: longitude, circleRadius: circleRadius, currentLocation: self.location, duration: serviceDuration, creatorImage: creatorImage, creatorName: creatorName, creatorID: creatorID))

                                            self.updateCollectionView()
                                            }
                                            
                                        }
                                    } else {
                                    creatorImage = nil

                                    self.array.append(ServiceCategoryModel(serviceTitle: serviceName, servicePay: String(servicePay), serviceID: serviceID, latitude: latitude, longitude: longitude, circleRadius: circleRadius, currentLocation: self.location, duration: serviceDuration, creatorImage: creatorImage, creatorName: creatorName, creatorID: creatorID))

                                    self.updateCollectionView()
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                }
        }
    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    
    
    
}
