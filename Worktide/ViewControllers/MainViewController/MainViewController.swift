//
//  MainViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-29.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import MapKit

protocol MainViewControllerDelegate {
    func changeUsersAddress(usersAddress:String)
}


class MainViewController:UITableViewController, CLLocationManagerDelegate,UITabBarControllerDelegate, CollectionViewCellDelegate, MainViewControllerDelegate {
    
    var usersDisplayMessage = ""
    
    var featuredServiceTitleArray = [String]()
    var serviceSpotlightModelArray = [[ServiceSpotlightModel]]()
    
    var didGetLocationAlready = false
    let locationManager = CLLocationManager()
    var locationValue:CLLocationCoordinate2D!
    
    var usersAddress:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfAuthenticated()
        
        setupTableView()
        getSelfProfileData()
        getMainViewData()
        
        self.tabBarController?.delegate = self
    }
    
    func addressToCoordinates(){

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(usersAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                return
            }
            self.locationValue = location.coordinate
            // Use your location
        }
    }
    
    func setupNavigationBar(){
        var topText = NSLocalizedString("No Address Found", comment: "")
        var bottomText = NSLocalizedString("Tap Here ▼", comment: "")
        
        if(usersAddress != nil){
            if let dotRange = usersAddress.range(of: ",") {
              usersAddress.removeSubrange(dotRange.lowerBound..<usersAddress.endIndex)
            }
            topText = NSLocalizedString("Results For", comment: "")
            bottomText = NSLocalizedString("\(usersAddress!) ▼", comment: "")
            addressToCoordinates()
        } else {
            let viewController = GetUserLocationController()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.backButton.isHidden = true
            viewController.fromMainViewController = true
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.black,
                               NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 18)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                                  NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 16)]

        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters as [NSAttributedString.Key : Any])
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters as [NSAttributedString.Key : Any])


        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)

        let titleLabel = UILabel()
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        navigationItem.titleView = titleLabel
        
        navigationItem.titleView?.addTapGestureRecognizer{
            let viewController = GetUserLocationController()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.fromMainViewController = true
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
    }
    
    //COLLECTION VIEW---------------------------------------------------------------------------------
    
    func setupTableView(){
        
        tableView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(MainViewHeader.self, forHeaderFooterViewReuseIdentifier: "MainViewHeader")
        tableView.register(SectionTitleHeader.self, forHeaderFooterViewReuseIdentifier: "SectionTitleHeader")
        tableView.register(CategoryCollectionCell.self, forCellReuseIdentifier: "CategoryCollectionCell")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "CollectionViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        serviceSpotlightModelArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch (section) {
        case 0:
            let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainViewHeader") as! MainViewHeader
            headerView.messageBoardText.text = usersDisplayMessage
            headerView.messageBoardText.adjustsFontSizeToFitWidth = false
            return headerView
        default:
            let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionTitleHeader") as! SectionTitleHeader

            headerView.title.text = featuredServiceTitleArray[section - 1]
            if(serviceSpotlightModelArray[section - 1].count > 6){
                headerView.seeAll.isHidden = false
            } else {
                headerView.seeAll.isHidden = true
            }
                           
            return headerView

        }
    }
    
    func didTapCell(_ row: Int, _ section: Int) {
        
        let viewController = UserServiceController(collectionViewLayout: UICollectionViewFlowLayout())
        let section = serviceSpotlightModelArray[section]
        let model = section[row]
        viewController.userID = model.creatorID!
        viewController.title = model.creatorName
        viewController.usersPhoto = model.creatorPhoto
        viewController.location = locationValue
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func selectedCategory(_ indexPath: IndexPath) {
       let viewController = ServicesByCategoryController(collectionViewLayout: UICollectionViewFlowLayout())
        switch indexPath.row {
        case 0:
            viewController.serviceCategory = "Home"
        case 1:
            viewController.serviceCategory = "Car"
        case 2:
            viewController.serviceCategory = "Parlor"
        case 3:
            viewController.serviceCategory = "Other"
        default:
            break
        }
        viewController.location = locationValue
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        default:
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.serviceSpotlightModelArray = serviceSpotlightModelArray[indexPath.section - 1]
            cell.sectionNumber = indexPath.section - 1
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        default:
            return 120
        }
    }
    
    func getMainViewData(){
        
        let db = Firestore.firestore()
        db.collection("ServiceSpotlight").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        //GET ALL SERVICE SPOTLIGHT JOBS
                        
                        let documentSet = document.get("serviceSet") as! Int
                        
                        self.featuredServiceTitleArray.append(document.get("spotlightTitle") as! String)
                        
                        var serviceSpotlightModel = [ServiceSpotlightModel]()
                        var numberOfRuns = 0
                        
                        let servicesID = document.get("servicesID") as! [String]
                        for service in servicesID{
                            //read service data of serviceSpotlight
                            let db = Firestore.firestore()
                            db.collection("Services").document(service).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let documentID = document.documentID
                                    let creatorID = document.get("creatorID") as! String
                                    
                                    let db = Firestore.firestore()
                                    db.collection("Users").document(creatorID).getDocument { (document, error) in
                                        if let document = document, document.exists {
                                            let creatorName = document.get("usersName") as! String
                                            
                                            var profileImage = UIImage(named: "lightBlueBackground")
                                            //get user profile picture
                                            let photoURL = document.get("userPhotoURL") as? String ?? "0"
                                            if(photoURL != "0"){
                                                let storageRef = Storage.storage().reference(forURL: photoURL)
                                                storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                                                    if error != nil {
                                                        let initials = creatorName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                                                        let initialedImage = profileImage!.textToImage(drawText: initials)
                                                        serviceSpotlightModel.append(ServiceSpotlightModel(creatorID:creatorID, creatorPhoto: initialedImage, creatorName: creatorName, documentID: documentID, set: documentSet))
                                                        
                                                        numberOfRuns += 1
                                                        if(numberOfRuns == servicesID.count){
                                                            self.serviceSpotlightModelArray.append(serviceSpotlightModel)
                                                            self.sortArray()
                                                        }
                                                    } else {
                                                        profileImage = UIImage(data: data!)!
                                                        serviceSpotlightModel.append(ServiceSpotlightModel(creatorID:creatorID, creatorPhoto: profileImage, creatorName: creatorName, documentID: documentID, set: documentSet))
                                                        
                                                        numberOfRuns += 1
                                                        if(numberOfRuns == servicesID.count){
                                                            self.serviceSpotlightModelArray.append(serviceSpotlightModel)
                                                            self.sortArray()
                                                        }
                                                        
                                                    }
                                                }
                                            } else {
                                                let initials = creatorName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first ?? " ")") + "\($1.first ?? " ")" }
                                                let initialedImage = profileImage!.textToImage(drawText: initials)
                                                
                                                serviceSpotlightModel.append(ServiceSpotlightModel(creatorID:creatorID, creatorPhoto: initialedImage, creatorName: creatorName, documentID: documentID, set: documentSet))
                                                
                                                numberOfRuns += 1
                                                if(numberOfRuns == servicesID.count){
                                                    self.serviceSpotlightModelArray.append(serviceSpotlightModel)
                                                    self.sortArray()
                                                }
                                            }
                                            
                                        } else {
                                            print("Document does not exist")
                                        }
                                        
                                        
                                    }
                                    
                                } else {
                                    //TODO DELETE FROM SERVICESPOTLIGHT IF DOES NOT EXIST
                                    print(service)
                                    numberOfRuns += 1
                                    self.sortArray()
                                    
                                }
                            }
                        }
                        
    
                        
                    }
                    self.sortArray()
                    self.updateTableView()
                }
        }
        
        //getUsersSavedLocation
        guard let userID = Auth.auth().currentUser?.uid
            else {
                self.usersAddress = UserDefaults.standard.string(forKey: "usersAddress")
                setupNavigationBar()
                return
            }
        db.collection("Users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.usersAddress = document.get("usersSavedAddress") as? String ?? UserDefaults.standard.string(forKey: "usersAddress")
                
                self.setupNavigationBar()
            } else {
                print("Document does not exist")
            }
        }

        
        
        /*
        let bookingsDB = Firestore.firestore()
        bookingsDB.collectionGroup("Appointments").whereField("status", isEqualTo: 0)

        bookingsDB.collection("Bookings").whereField("customer", isEqualTo: userID).whereField("status", isEqualTo: 0).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.customerAppointmentCount = 0
            for document in documents{
                let endDate = (document.get("endDate") as! Timestamp).dateValue()
                if(endDate > Date()){
                    self.customerAppointmentCount += 1
                }
                self.appointmentCount = self.customerAppointmentCount + self.serviceAppointmentCount
                self.updateTableView()
            }
        }
        
        bookingsDB.collection("Bookings").whereField("servicer", isEqualTo: userID).whereField("status", isEqualTo: 0).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.serviceAppointmentCount = 0
            
            for document in documents{
                let endDate = (document.get("endDate") as! Timestamp).dateValue()
                if(endDate > Date()){
                    self.serviceAppointmentCount += 1
                }
                self.appointmentCount = self.customerAppointmentCount + self.serviceAppointmentCount
                self.updateTableView()
            }
        }
       */

    }
    //DELEGATES---------------------------------------------------------------------------
    func changeUsersAddress(usersAddress: String) {
        self.usersAddress = usersAddress
        setupNavigationBar()
    }
    

   //---------------------------------------------------------------------------------------
    func updateTableView () {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func sortArray(){
        serviceSpotlightModelArray.sort(by: {($0.first?.set ?? Int.max) < ($1.first?.set ?? Int.max)})
        self.updateTableView()
    }
    
    //SETUP PROFILE IMAGE--------------------------------------------------------------------------------
    
    func getSelfProfileData(){
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let fullName = document.get("usersName") as? String
            let fullNameArr = fullName!.components(separatedBy: " ")
            self.usersDisplayMessage = "What can we we help you with today, \(fullNameArr[0])?"
            self.updateTableView()
            
        }
        
    }

    
    
    //--------------------------------------------------------------------------------
    
    func checkIfAuthenticated(){
        if Auth.auth().currentUser == nil {
            ///user is not logged in
            usersDisplayMessage = "What service do you need today?"
        } 
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let tabBarIndex = tabBarController.selectedIndex

        if tabBarIndex == 0 {
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
}


extension MainViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
