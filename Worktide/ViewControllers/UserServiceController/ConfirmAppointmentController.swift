//
//  ConfirmAppointmentController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-19.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MapKit
import GoogleMaps
import FirebaseAuth

class ConfirmAppointmentController:UIViewController, GMSMapViewDelegate{
    
    var userID:String!
    var serviceDuration:Int!
    var dateChosen:Date!
    var timeChosen:String!
    var location:CLLocationCoordinate2D!
    
    var latitude:Double!
    var longitude:Double!
    
    var dateAlreadyBooked = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    public let serviceTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textView.numberOfLines = 0
        textView.text = BookServiceDetails.details.serviceName
        return textView
    }()
    
    private let personIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "createServiceIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let usersName: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        textView.text = BookServiceDetails.details.usersName
        return textView
    }()
    
    private let priceIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "priceIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let priceLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        textView.text = BookServiceDetails.details.servicePay
        return textView
    }()
    
    private let timeIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "timeIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let timeLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        textView.text = BookServiceDetails.details.serviceDate
        return textView
    }()
    
    private let confirmButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm Appointment", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    public let serviceLocation: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        textView.numberOfLines = 0
        textView.text = "Service Location"
        return textView
    }()
    
    private let mapView:GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setMinZoom(10, maxZoom: mapView.maxZoom)
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.zoomGestures = false
        mapView.settings.scrollGestures = false
        mapView.layer.cornerRadius = 12
        return mapView
    }()
    
    public let locationText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        textView.numberOfLines = 0
        return textView
    }()
    
    let marker:GMSMarker = {
        let marker = GMSMarker()
        let currentPosition = UIImageView(image: UIImage(named: "navigationMarker"))
        currentPosition.frame.size = CGSize(width: 40, height: 40)
        marker.iconView = currentPosition
        return marker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        updateLocation()
        addAuthStateChangeListener()
    }
    
    func setupView(){
        
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(serviceTitle)
        serviceTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        serviceTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        scrollView.addSubview(personIcon)
        personIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        personIcon.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 50).isActive = true
        personIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        personIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(usersName)
        usersName.leadingAnchor.constraint(equalTo: personIcon.trailingAnchor, constant: 25).isActive = true
        usersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        usersName.centerYAnchor.constraint(equalTo: personIcon.centerYAnchor).isActive = true
        
        scrollView.addSubview(priceIcon)
        priceIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        priceIcon.topAnchor.constraint(equalTo: personIcon.bottomAnchor, constant: 25).isActive = true
        priceIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        priceIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: priceIcon.trailingAnchor, constant: 25).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: priceIcon.centerYAnchor).isActive = true
        
        scrollView.addSubview(timeIcon)
        timeIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        timeIcon.topAnchor.constraint(equalTo: priceIcon.bottomAnchor, constant: 25).isActive = true
        timeIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        timeIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 25).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        
        scrollView.addSubview(serviceLocation)
        serviceLocation.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 50).isActive = true
        serviceLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        scrollView.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mapView.topAnchor.constraint(equalTo: serviceLocation.bottomAnchor, constant: 25).isActive = true
        mapView.addTapGestureRecognizer{
            self.openMapForPlace()
        }
        
        scrollView.addSubview(locationText)
        locationText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        locationText.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 25).isActive = true
        locationText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        if(BookServiceDetails.details.circleDistance == 0){
            locationText.text = "Tap on the map to see where to go."
        } else {
            locationText.text = "This service will come to you."
        }
        
        //add to last view in scrollview
        locationText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -150).isActive = true
        
        view.addSubview(confirmButton)
        confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if(!isUserAuthenticated()){
            confirmButton.setTitle("Sign in to book", for: .normal)
        }
    }
    
    
    func updateLocation(){
        
        if(BookServiceDetails.details.circleDistance != 0){ //this is own location
            latitude = location.latitude
            longitude = location.longitude
        } else {
            latitude = BookServiceDetails.details.latitude! //this is service location
            longitude = BookServiceDetails.details.longitude!
        }
        
        mapView.delegate = self
        
        // MarkerSetupUP
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        mapView.animate(to: camera)
        
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
        
        

    }
    
    func openMapForPlace() {

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = serviceTitle.text
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc func doneButton(sender: UIButton!) {
        switch sender {
        case confirmButton:
            if(isUserAuthenticated()){
                showLoading()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let dateInTime = dateFormatter.date(from: timeChosen)
                
                let hour = Calendar.current.component(.hour, from: dateInTime!)
                let min = Calendar.current.component(.minute, from: dateInTime!)
                let startDate = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: dateChosen)
                let endDate = startDate?.addingTimeInterval(TimeInterval(60 * serviceDuration))
                
                let bookingsDB = Firestore.firestore()
                bookingsDB.collection("Bookings").whereField("servicer", isEqualTo: userID!).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            for document in querySnapshot!.documents {
                                let startTime = (document.get("startDate") as! Timestamp).dateValue() - 60 //minus 60seconds to account for same time
                                let endTime = (document.get("endDate") as! Timestamp).dateValue() - 60
                                
                                if((startDate?.isBetween(startTime, and: endTime))! || (endDate?.isBetween(startTime, and: endTime))!){
                                    self.dateAlreadyBooked = true
                                }
                            }
                            
                            if(!self.dateAlreadyBooked){
                                guard let userID = Auth.auth().currentUser?.uid else { return }
                                let db = Firestore.firestore()
                                db.collection("Bookings").document().setData([
                                    "servicer": self.userID!,
                                    "customer": userID,
                                    "startDate": startDate!,
                                    "endDate": endDate!,
                                    "serviceID":  BookServiceDetails.details.serviceID!,
                                    "servicePrice": self.priceLabel.text!,
                                    "serviceTitle": self.serviceTitle.text!,
                                    "latitude": self.latitude!,
                                    "longitude": self.longitude!,
                                    "circleRadius": BookServiceDetails.details.circleDistance!,
                                    "status": 0
                                ]){ err in
                                    if err != nil {
                                        
                                        self.dismiss(animated: true, completion: {
                                            self.showAlert()
                                        })
                                    } else {
                                        let center = UNUserNotificationCenter.current()

                                        let content = UNMutableNotificationContent()
                                        content.body = "You have an appointment today."
                                        content.sound = UNNotificationSound.default
                                        content.categoryIdentifier = "reminderNotification"

                                        // Setup trigger time
                                        var calendar = Calendar.current
                                        calendar.timeZone = TimeZone.current
                                        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self.dateChosen)
                                        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

                                        // Create request
                                        let uniqueID = UUID().uuidString // Keep a record of this if necessary
                                        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
                                        center.add(request) // Add the notification request
                                        
                                        self.dismiss(animated: true, completion: {self.showSuccess()})
                                        
                                    }
                                }
                            } else {
                                self.dismiss(animated: true, completion: {
                                    self.showTakenSpot()
                                })
                            }
                            
                            
                        }
                }
            } else {
                let viewController = LoginController()
                viewController.dismissViewController = true
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overFullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
            
            

        default:
            break
        }
    }
    
    func showLoading(){
        let alert = UIAlertController(title: nil, message: "Uploading", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess() {
        let alert = UIAlertController(title: "Booked", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: {
            _ = self.navigationController?.popToRootViewController(animated: true)
            
        })} )
    }
    
    func showTakenSpot() {
        let alert = UIAlertController(title: "Someone took this spot", message: "Please try a different time", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: {_ = self.navigationController?.popToRootViewController(animated: true)})} )
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    //-----------------------------------------------------------
    
    func addAuthStateChangeListener(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if(self.isUserAuthenticated()){
                self.confirmButton.setTitle("Confirm Appointment", for: .normal)
            }
        }
    }
    
    //-----------------------------------------------------------
    func isUserAuthenticated() -> Bool{
        if Auth.auth().currentUser == nil {
            ///user is not logged in
            return false
        } else {
            return true
        }
    }
}
