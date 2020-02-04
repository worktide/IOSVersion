//
//  ServiceLocation.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-04.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps


class ServiceLocation:UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var didGetLocationAlready = false
    
    let locationManager = CLLocationManager()
    
    var latitude:Double?
    var longitude:Double?
    
    var fromChangeService = false
    var delegate: ChangeServiceDelegate?
    
    private let mapView:GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setMinZoom(10, maxZoom: mapView.maxZoom)
        return mapView
    }()
    
    let marker:GMSMarker = {
        let marker = GMSMarker()
        let currentPosition = UIImageView(image: UIImage(named: "navigationMarker"))
        currentPosition.frame.size = CGSize(width: 40, height: 40)
        marker.iconView = currentPosition
        return marker
    }()
    
    public let circleRadius:GMSCircle = {
        let circle = GMSCircle()
        circle.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circle.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circle.strokeWidth = 2.5
        circle.radius = 1000
        return circle
    }()
    
    private let plusButton:UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "addIcon"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    private let minusButton:UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "minusIcon"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let serviceAreaType:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let serviceAreaTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Service Area"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let serviceAreaDesc:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select this if you are going to them for your service, and adjust how far you are willing to go."
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
       }()
    
    private let serviceAreaSelected:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Selected"
        label.textColor = .systemBlue
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        return label
    }()
    
    
    private let serviceSetLocationType:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let serviceSetTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set Location"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let serviceSetDesc:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose this if you have your own location that people can come to you."
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
       }()
    
    private let serviceSetSelected:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Selected"
        label.textColor = .systemBlue
        label.isHidden = true
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        
        if(fromChangeService){
            didGetLocationAlready = true
            self.updateLocation(latitude: latitude!, longitude: longitude!)
            if(circleRadius.radius == 0){
                serviceSetSelected.isHidden = false
                serviceAreaSelected.isHidden = true
            }
        } else {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        title = "Service Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(plusButton)
        plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(minusButton)
        minusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        minusButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        scrollView.addSubview(serviceAreaType)
        serviceAreaType.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        serviceAreaType.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.83).isActive = true
        serviceAreaType.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        serviceAreaType.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        serviceAreaType.heightAnchor.constraint(equalToConstant: 150).isActive = true
        serviceAreaType.addTapGestureRecognizer{
            if (self.latitude != nil && self.longitude != nil){
                self.circleRadius.radius = 1000
                let camera = GMSCameraPosition.camera(withLatitude: self.latitude!, longitude: self.longitude!, zoom: 14)
                self.mapView.animate(to: camera)
                self.circleRadius.position = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                self.circleRadius.map = self.mapView
                self.plusButton.isHidden = false
                self.minusButton.isHidden = false
                self.serviceAreaSelected.isHidden = false
                self.serviceSetSelected.isHidden = true
            }
        }
        
        serviceAreaType.addSubview(serviceAreaTitle)
        serviceAreaTitle.leadingAnchor.constraint(equalTo: serviceAreaType.leadingAnchor, constant: 15).isActive = true
        serviceAreaTitle.trailingAnchor.constraint(equalTo: serviceAreaType.trailingAnchor, constant: -15).isActive = true
        serviceAreaTitle.topAnchor.constraint(equalTo: serviceAreaType.topAnchor, constant: 15).isActive = true
        
        serviceAreaType.addSubview(serviceAreaDesc)
        serviceAreaDesc.leadingAnchor.constraint(equalTo: serviceAreaType.leadingAnchor, constant: 15).isActive = true
        serviceAreaDesc.trailingAnchor.constraint(equalTo: serviceAreaType.trailingAnchor, constant: -15).isActive = true
        serviceAreaDesc.topAnchor.constraint(equalTo: serviceAreaTitle.bottomAnchor, constant: 10).isActive = true
        
        serviceAreaType.addSubview(serviceAreaSelected)
        serviceAreaSelected.centerXAnchor.constraint(equalTo: serviceAreaType.centerXAnchor).isActive = true
        serviceAreaSelected.bottomAnchor.constraint(equalTo: serviceAreaType.bottomAnchor, constant: -15).isActive = true
        serviceAreaSelected.topAnchor.constraint(equalTo: serviceAreaDesc.bottomAnchor, constant: 15).isActive = true
        
        scrollView.addSubview(serviceSetLocationType)
        serviceSetLocationType.leadingAnchor.constraint(equalTo: serviceAreaType.trailingAnchor, constant: 10).isActive = true
        serviceSetLocationType.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.83).isActive = true
        serviceSetLocationType.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        serviceSetLocationType.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        serviceSetLocationType.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        serviceSetLocationType.heightAnchor.constraint(equalToConstant: 150).isActive = true
        serviceSetLocationType.addTapGestureRecognizer{
            if (self.latitude != nil && self.longitude != nil){
                self.plusButton.isHidden = true
                self.minusButton.isHidden = true
                let camera = GMSCameraPosition.camera(withLatitude: self.latitude!, longitude: self.longitude!, zoom: 18)
                self.mapView.animate(to: camera)
                self.circleRadius.map = nil
                self.serviceAreaSelected.isHidden = true
                self.serviceSetSelected.isHidden = false
                
                //set circle to 0 so we know which one was chosen
                self.circleRadius.radius = 0
            }
        }
        
        serviceSetLocationType.addSubview(serviceSetTitle)
        serviceSetTitle.leadingAnchor.constraint(equalTo: serviceSetLocationType.leadingAnchor, constant: 15).isActive = true
        serviceSetTitle.trailingAnchor.constraint(equalTo: serviceSetLocationType.trailingAnchor, constant: -15).isActive = true
        serviceSetTitle.topAnchor.constraint(equalTo: serviceSetLocationType.topAnchor, constant: 15).isActive = true
        
        serviceSetLocationType.addSubview(serviceSetSelected)
        serviceSetSelected.centerXAnchor.constraint(equalTo: serviceSetLocationType.centerXAnchor).isActive = true
        serviceSetSelected.bottomAnchor.constraint(equalTo: serviceSetLocationType.bottomAnchor, constant: -15).isActive = true
        
        serviceSetLocationType.addSubview(serviceSetDesc)
        serviceSetDesc.leadingAnchor.constraint(equalTo: serviceSetLocationType.leadingAnchor, constant: 15).isActive = true
        serviceSetDesc.trailingAnchor.constraint(equalTo: serviceSetLocationType.trailingAnchor, constant: -15).isActive = true
        serviceSetDesc.topAnchor.constraint(equalTo: serviceSetTitle.bottomAnchor).isActive = true
        serviceSetDesc.bottomAnchor.constraint(equalTo: serviceSetSelected.topAnchor).isActive = true
        serviceSetDesc.centerYAnchor.constraint(equalTo: serviceSetLocationType.centerYAnchor).isActive = true
        
    }
    
    func updateLocation(latitude:Double, longitude:Double){
        
        mapView.delegate = self
        
        // MarkerSetupUP
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
        mapView.animate(to: camera)
        
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
        
        circleRadius.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circleRadius.map = mapView
        

    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        circleRadius.position = coordinate
        marker.position = coordinate
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude

    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if(didGetLocationAlready == false){
            didGetLocationAlready = true
            
            self.latitude = locValue.latitude
            self.longitude = locValue.longitude
            self.updateLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            locationManager.stopUpdatingLocation()
            
        }
        
    }
    
    @objc func buttonAction(sender: UIButton) {
        switch sender {
        case self.plusButton:
            if(circleRadius.radius <= 12500){
                self.circleRadius.radius = self.circleRadius.radius + 600
            }
            
        case self.minusButton:
            if(circleRadius.radius >= 500){
                self.circleRadius.radius = self.circleRadius.radius - 150
            }
        default:
            break
        }
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(fromChangeService){
                delegate?.changeServiceLocation(latitude: latitude!, longitude: longitude!, circleDistance: circleRadius.radius)
                self.dismiss(animated: true, completion: nil)
            } else {
                let viewController = ServicePayController()
                InputDetails.details.longitude = longitude
                InputDetails.details.latitude = latitude
                InputDetails.details.circleDistance = circleRadius.radius
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}



