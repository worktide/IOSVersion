//
//  ViewAppointmentController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-27.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MapKit
import GoogleMaps
import FirebaseAuth
import MessageUI

class ViewAppointmentController:UIViewController, GMSMapViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    var bookingID:String!
    var usersPhoneNumber:String!
    var latitude:Double!
    var longitude:Double!
    var customerID:String!
    
    var circleRadius:Double!
    
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
        return textView
    }()
    
    private let confirmButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Options", for: .normal)
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
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if(customerID == userID){
            if(circleRadius == 0){
                locationText.text = "Tap on the map to see where to go."
            } else {
                locationText.text = "This service will come to you."
            }
        } else {
            if(circleRadius == 0){
                locationText.text = "They will come to you, keep an eye out for a call from them.\n\nDon't forget to collect your payment once you are done."
            } else {
                locationText.text = "Meet them on this location, tap on the map to see where to go. You could also give them a call.\n\nDon't forget to collect your payment once you are done."
            }
        }
        
        //add to last view in scrollview
        locationText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -150).isActive = true
        
        view.addSubview(confirmButton)
        confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func updateLocation(){
        
        mapView.delegate = self
        
        // MarkerSetupUP
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
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
            showActionSheet()

        default:
            break
        }
    }
    
    func showActionSheet(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let fullNameArr = usersName.text!.components(separatedBy: " ")
        
        alert.addAction(UIAlertAction(title: "Contact \(fullNameArr[0])", style: .default, handler: { (_) in
            
            if(MFMessageComposeViewController.canSendText()){
                self.showCallingAlert()
            } else {
                let phoneNumber = self.usersPhoneNumber.filter("0123456789.".contains)
                let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            
        }))
        
        /*alert.addAction(UIAlertAction(title: "Cancel Appointment", style: .cancel, handler: { (_) in
            self.showCancellingAlert()
            
        }))*/
        
        
        alert.addAction(UIAlertAction(title: "Email Support", style: .default, handler: { (_) in
            self.sendEmail()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCallingAlert(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call \(self.usersPhoneNumber!)", style: .default, handler: { (_) in
            let phoneNumber = self.usersPhoneNumber.filter("0123456789.".contains)
            let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }))
        
    alert.addAction(UIAlertAction(title: "Text \(self.usersPhoneNumber!)", style: .default, handler: { (_) in
             if (MFMessageComposeViewController.canSendText()) {
                let phoneNumber = self.usersPhoneNumber.filter("0123456789.".contains)
                let controller = MFMessageComposeViewController()
                controller.recipients = [phoneNumber]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    /*func showCancellingAlert(){
        let alert = UIAlertController(title: "Are you sure?", message: "Canceling the appointment 12 hours before the appointment may cause penalties.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.showCancelling()
            let db = Firestore.firestore()
            db.collection("Bookings").document(self.bookingID).setData([
                "status": 1
            ], merge: true){ err in
                if let err = err {
                    self.showError()
                } else {
                    self.dismiss(animated: true, completion: {
                        self.showCancelled()
                    })
                }
            }

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCancelling(){
        let alert = UIAlertController(title: nil, message: "Cancelling", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Please try again.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: {self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)})} )
    }
    
    func showCancelled() {
        let alert = UIAlertController(title: "Cancelled", message: "We've sent a notification to them.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: {self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)})} )
    }*/
    
    func sendEmail(){
    
        if !MFMailComposeViewController.canSendMail() {
            self.showEmailAddress()
        } else {
            emailSetup()
        }
        
    }
    
    func showEmailAddress() {
        let alert = UIAlertController(title: "Email us at", message: "worktide@outlook.com", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func emailSetup() {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["worktide@outlook.com"])
        composeVC.setSubject("Booking Support")
        composeVC.setMessageBody("Booking ID: \(bookingID ?? "not available")\n", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
