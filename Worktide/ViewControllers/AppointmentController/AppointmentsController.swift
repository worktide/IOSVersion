//
//  AppointmentsController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-26.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AppointmentsController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var appointmentsArray = [AppointmentsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getData()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    func setupCollectionView(){
        let inset = UIEdgeInsets(top: 0, left: 25, bottom: 80, right: 25)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.register(CollectionViewHeaderCell.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeader")
        collectionView.register(SelectAppointmentCell.self, forCellWithReuseIdentifier: "SelectAppointmentCell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appointmentsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //FOR HEADER VIEWS
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeader", for: indexPath) as! CollectionViewHeaderCell
            headerView.messageBoardText.text = "Select Appointment"
            headerView.messageBoardText.adjustsFontSizeToFitWidth = true
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = appointmentsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAppointmentCell", for: indexPath as IndexPath) as! SelectAppointmentCell
        cell.appointmentDate.text = model.serviceDateDisplay
        cell.serviceTitle.text = model.serviceTitle
        
        
        if(model.otherUserImage == nil){
            cell.userProfileImage.removeAllSubviews()
            cell.userProfileImage.image = UIImage(named: "lightBlueBackground")
            
            let initials = model.otherName!.initials
            cell.userProfileImage.addInitials(initial:initials, textSize: 18)
        } else {
            cell.userProfileImage.removeAllSubviews()
            cell.userProfileImage.image = model.otherUserImage
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = appointmentsArray[indexPath.row]
        let viewController = ViewAppointmentController()
        viewController.serviceTitle.text = model.serviceTitle
        viewController.timeLabel.text = model.serviceDateDisplay
        viewController.priceLabel.text = model.servicePrice
        viewController.usersName.text = model.otherName
        viewController.latitude = model.latitude
        viewController.longitude = model.longitude
        viewController.circleRadius = model.circleRadius
        viewController.usersPhoneNumber = model.usersPhoneNumber
        viewController.bookingID = model.bookingID
        viewController.customerID = model.customerID
        self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: 120)
    }
    
    func getData(){
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("Bookings").whereField("customer", isEqualTo: userID).whereField("status", isEqualTo: 0).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let startDate = (document.get("startDate") as! Timestamp).dateValue()
                        if(startDate > Date()){
                            
                            let servicePrice = document.get("servicePrice") as! String
                            let serviceTitle = document.get("serviceTitle") as! String
                            let servicerID = document.get("servicer") as! String
                            let circleRadius = document.get("circleRadius") as! Double
                            let latitude = document.get("latitude") as! Double
                            let longitude = document.get("longitude") as! Double
                            let bookingID = document.documentID
                            let customerID = document.get("customer") as! String
                            
                            db.collection("Users").document(servicerID).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let usersName = document.get("usersName") as! String
                                    let usersPhoneNumber = document.get("usersPhoneNumber") as! String
                                    
                                    
                                    let photoURL = document.get("userPhotoURL") as? String ?? "0"
                                    if(photoURL != "0"){
                                        let storageRef = Storage.storage().reference(forURL: photoURL)
                                        storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                                            if error != nil {
                                                self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: nil, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID, customerID: customerID))
                                                self.sortArray()
                                                self.updateCollectionView()

                                            } else {
                                                self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: UIImage(data: data!)!, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID, customerID: customerID))
                                                self.sortArray()
                                                self.updateCollectionView()
                                                }
                                                
                                            }
                                        } else {
                                        self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: nil, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID, customerID: customerID))
                                            self.sortArray()
                                            self.updateCollectionView()
                                    }
                                    
                                } else {
                                    print("Document does not exist")
                                }
                            }
                            
                            
                            
                        }
                        self.updateCollectionView()
                    }
                }
        }
        
        db.collection("Bookings").whereField("servicer", isEqualTo: userID).whereField("status", isEqualTo: 0).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let startDate = (document.get("startDate") as! Timestamp).dateValue()
                        if(startDate > Date()){
                            
                            let servicePrice = document.get("servicePrice") as! String
                            let serviceTitle = document.get("serviceTitle") as! String
                            let customerID = document.get("customer") as! String
                            let circleRadius = document.get("circleRadius") as! Double
                            let latitude = document.get("latitude") as! Double
                            let longitude = document.get("longitude") as! Double
                            let bookingID = document.documentID
                            
                            db.collection("Users").document(customerID).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let usersName = document.get("usersName") as! String
                                    let usersPhoneNumber = document.get("usersPhoneNumber") as! String
                                    
                                    let photoURL = document.get("userPhotoURL") as? String ?? "0"
                                    if(photoURL != "0"){
                                        let storageRef = Storage.storage().reference(forURL: photoURL)
                                        storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                                            if error != nil {
                                                self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: nil, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID, customerID: customerID))
                                                self.sortArray()
                                                self.updateCollectionView()

                                            } else {
                                                self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: UIImage(data: data!)!, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID,customerID: customerID))
                                                self.sortArray()
                                                self.updateCollectionView()
                                                }
                                                
                                            }
                                        } else {
                                            self.appointmentsArray.append(AppointmentsModel(serviceTitle: serviceTitle, servicePrice: servicePrice, startDate: startDate, otherName: usersName, userImage: nil, circleRadius: circleRadius, latitude: latitude, longitude: longitude, usersPhoneNumber: usersPhoneNumber, bookingID: bookingID,customerID: customerID))
                                            self.sortArray()
                                            self.updateCollectionView()
                                    }
                                    
                                } else {
                                    print("Document does not exist")
                                }
                            }
                            
                            
                            
                        }
                        self.updateCollectionView()
                    }
                }
        }
    }
    
    func sortArray(){
        self.appointmentsArray.sort(by: { $0.serviceDate!.compare($1.serviceDate!) == .orderedAscending })
        
    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    
    
    
}
