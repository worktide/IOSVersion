//
//  UserServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-26.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import MapKit
import Firebase

struct BookServiceDetails {
    static var details: BookServiceDetails = BookServiceDetails()

    var usersName:String?
    var serviceName:String?
    var latitude:Double?
    var longitude:Double?
    var circleDistance:Double?
    var servicePay:String?
    var serviceDuration:String?
    var serviceDate:String?
    var serviceID:String?
}

class UserServiceController:UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    
    var userID = ""
    var usersPhoto:UIImage!
    
    var location:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var didGetLocationAlready = false
    
    var servicesArray = [SpecifiedServiceModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        
        if CLLocationManager.locationServicesEnabled() {
         switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                getUserData()
                showUserProfileIfEmpty()
            case .authorizedAlways, .authorizedWhenInUse:
                if(location == nil){
                    getCurrentLocation()
                } else {
                    getUserData()
                    showUserProfileIfEmpty()
            }
            @unknown default:
                getUserData()
                showUserProfileIfEmpty()
            }
        } else {
            getUserData()
            showUserProfileIfEmpty()
        }
    }
    
    func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if(didGetLocationAlready == false){
            didGetLocationAlready = true
            location = locValue
            getUserData()
            showUserProfileIfEmpty()
            
        }
        
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    
    
    
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 0, left: 25, bottom: 80, right: 25)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.delegate = self
        collectionView.register(UserSerivceHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(ServicesCell.self, forCellWithReuseIdentifier: "MyServicesCell")
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return servicesArray.count
        default:
            return 0
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyServicesCell", for: indexPath) as! ServicesCell
        let model = servicesArray[indexPath.row]
        cell.serviceTitle.text = model.serviceTitle
        cell.servicePrice.text = model.servicePayString
        cell.serviceDuration.text = model.durationString
        cell.serviceDistance.text = model.locationDistance
        
        if(UserDefaults.standard.bool(forKey: "hasSeenHold")){
            cell.holdForInformation.isHidden = true
        } else {
            cell.holdForInformation.isHidden = false
        }
        
        switch model.userInRange {
        case false:
            cell.bookNow.isHidden = true
        default:
            cell.bookNow.isHidden = false
        }
        return cell
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = servicesArray[indexPath.row]
        switch model.userInRange {
        case false:
            break
        default:
            BookServiceDetails.details.serviceID = model.serviceID
            BookServiceDetails.details.usersName = self.title
            BookServiceDetails.details.serviceName = model.serviceTitle
            BookServiceDetails.details.servicePay = model.servicePayString
            BookServiceDetails.details.serviceDuration = model.durationString
            BookServiceDetails.details.circleDistance = model.circleRadius
            BookServiceDetails.details.latitude = model.latitude
            BookServiceDetails.details.longitude = model.longitude
            
            let viewController = BookServicesController(collectionViewLayout: UICollectionViewFlowLayout())
            viewController.serviceDuration = model.serviceDuration
            viewController.userID = userID
            viewController.location = location
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //FOR HEADER VIEWS
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! UserSerivceHeader
            
            //set up image
            if(usersPhoto == UIImage()){
                headerView.name = self.title!
                
            } else {
                headerView.userProfileImage.removeAllSubviews()
                headerView.userProfileImage.image = usersPhoto
            }
            
            return headerView
        default:
            return reusableview
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    
    
    func getUserData(){
        let db = Firestore.firestore()
        db.collection("Services").whereField("creatorID", isEqualTo: userID).getDocuments { documentSnapshot, error in
           if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in documentSnapshot!.documents {
                    let serviceTitle = document.get("serviceName") as! String
                    let servicePay = String(document.get("servicePay") as! Int)
                    let serviceID = document.documentID
                    let latitude = document.get("latitude") as! Double
                    let longitude = document.get("longitude") as! Double
                    let circleDistance = document.get("circleDistance") as! Double
                    let serviceDuration = document.get("serviceDuration") as! Int
                    let jobDescription = document.get("serviceDescription") as? String
                    
                    
                    self.servicesArray.append(SpecifiedServiceModel(serviceTitle: serviceTitle, servicePay: servicePay, serviceID: serviceID, latitude: latitude, longitude: longitude, circleRadius: circleDistance, currentLocation: self.location, duration: serviceDuration, jobDescription: jobDescription))
                }
            self.updateCollectionView()
            }
            
            
        }
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){

        if (gestureRecognizer.state != UIGestureRecognizer.State.began){
            return
        }
        
        UserDefaults.standard.set(true, forKey: "hasSeenHold")

        let p = gestureRecognizer.location(in: self.collectionView)

        if let indexPath : NSIndexPath = (self.collectionView.indexPathForItem(at: p) as NSIndexPath?){
            let viewController = AboutServiceController(collectionViewLayout: UICollectionViewFlowLayout())
            viewController.serviceDescription = servicesArray[indexPath.row].jobDescription ?? ""
            viewController.serviceID = servicesArray[indexPath.row].serviceID
            viewController.latitude = servicesArray[indexPath.row].latitude
            viewController.longitude = servicesArray[indexPath.row].longitude
            viewController.circleRadius = servicesArray[indexPath.row].circleRadius
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.collectionView.register(TitleHeaders.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
            viewController.collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: "ImagesCell")
            viewController.collectionView.register(AboutServiceCell.self, forCellWithReuseIdentifier: "AboutServiceCell")
            viewController.collectionView.register(MapViewCell.self, forCellWithReuseIdentifier: "MapViewCell")
            self.present(navigationController, animated: true)
            
        }

    }
    
    func showUserProfileIfEmpty(){

        if(usersPhoto == nil || self.title == nil){
            let db = Firestore.firestore()
            db.collection("Users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let creatorName = document.get("usersName") as! String
                    self.title = creatorName
                    
                    let profileImage = UIImage(named: "lightBlueBackground")
                    //get user profile picture
                    let photoURL = document.get("userPhotoURL") as? String ?? "0"
                    if(photoURL != "0"){
                        let storageRef = Storage.storage().reference(forURL: photoURL)
                        storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                            if error != nil {
                                let initials = creatorName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                                let initialedImage = profileImage!.textToImage(drawText: initials)
                                
                                self.usersPhoto = initialedImage
                                self.updateCollectionView()
                            } else {
                                self.usersPhoto = UIImage(data: data!)!
                                self.updateCollectionView()
                            }
                        }
                    } else {
                        let initials = creatorName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                        let initialedImage = profileImage!.textToImage(drawText: initials)
                        
                        self.usersPhoto = initialedImage
                        self.updateCollectionView()
                        
                    }
                    
                } else {
                    print("Document does not exist")
                }
                
                
            }
        }
    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            _ = navigationController?.popViewController(animated: true)
        case self.navigationItem.rightBarButtonItem:
            createDynamicLink()
        default:
            break
        }
    }
    
     func createDynamicLink() {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "https://worktide.page.link"
        components.path = "/servicerID"
        
        let servicerID = URLQueryItem(name: "servicerID", value: userID)
        components.queryItems = [servicerID]
        
        guard let linkParameter = components.url else {return}
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://worktide.page.link") else {
            print("couldn't create FDL component")
            return
        }
        
        if let bundleID = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }
        shareLink.iOSParameters?.appStoreID = "1480167340"
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Services by \(self.title ?? "")"
        
        shareLink.shorten{(url, warning, error) in
            if error != nil{
                print("Error")
                return
            }
            guard let url = url else {return}
            print(url.absoluteString)
            
            self.showShareSheet(url)
            
        }
    }
    
    func showShareSheet(_ url:URL){
        let promoText = "Share \(self.title ?? "")'s services"
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    
    
}
