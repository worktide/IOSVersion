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


class ServiceLocation:UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, SendStringDataDelegate {
    
    var createServiceModel:CreateServiceModel!
    var latitude:Double?
    var longitude:Double?
    
    var fromChangeService = false
    var delegate: ChangeServiceDelegate?
    
    var address:String!
    var circleRadius:Double = 250
    var shouldUpdateMap = false
    
    private let setServiceAreaLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set Service Area"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let serviceAreaDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Turn this on for how far you are willing to go. Otherwise turn this off to have the customer come to you."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let switchButton:UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.isOn = true
        switchBtn.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switchBtn
    }()
    
    private let mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isRotateEnabled = false
        return mapView
    }()
    
    private let searchButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.isHidden = true
        return button
    }()
    
    let loadingSpinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: .gray)
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    private let plusButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.setImage(UIImage(named: "addIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    private let minusButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        button.setImage(UIImage(named: "minusIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        getLocationFromAddress()
        
        
    }
    
    
    //Setup View---------------------------------
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        title = "Service Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupView(){
        
        view.backgroundColor = .white
        view.addSubview(setServiceAreaLabel)
        view.addSubview(serviceAreaDescription)
        view.addSubview(switchButton)
        view.addSubview(mapView)
        view.addSubview(searchButton)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
        view.addSubview(loadingSpinner)
        
        setServiceAreaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        setServiceAreaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        setServiceAreaLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -15).isActive = true
        
        serviceAreaDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceAreaDescription.topAnchor.constraint(equalTo: setServiceAreaLabel.bottomAnchor, constant: 10).isActive = true
        serviceAreaDescription.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -15).isActive = true
        
        switchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: setServiceAreaLabel.centerYAnchor).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: serviceAreaDescription.bottomAnchor, constant: 30).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mapView.addGestureRecognizer(tap)
        
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        searchButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingSpinner.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor).isActive = true
        
        minusButton.topAnchor.constraint(equalTo: searchButton.topAnchor).isActive = true
        minusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        plusButton.topAnchor.constraint(equalTo: searchButton.topAnchor).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //Do Functions-------------------------------------
    
    
    
    //MapView---------------------------------------------
    
    func getLocationFromAddress(){
        
        if address == nil{
            address = UserDefaults.standard.string(forKey: "usersAddress")!
        }
        
        searchButton.setTitle(address, for: .normal)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            if error == nil{
                let location = placemarks?.first?.location
                    
                self.latitude = location!.coordinate.latitude
                self.longitude = location!.coordinate.longitude
                if self.shouldUpdateMap{
                    self.updateLocation()
                } else {
                    self.setupMaps()
                }
            } else {
                //error exists
                print(error!)
            }

        }
    }
    
    func setupMaps(){
        
        let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: false)
        

        let circle = MKCircle(center: location, radius: circleRadius)
        self.mapView.addOverlay(circle)
        
        if switchButton.isOn {
            let circle = MKCircle(center: location, radius: circleRadius)
            self.mapView.addOverlay(circle)
        } else {
            let annotation = MKPointAnnotation()
            annotation.title = address
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
            //self.mapView.cameraZoomRange = 1500
        }
    }
    
    func updateLocation(){
        
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.removeAnnotations(mapView.annotations)
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        mapView.setCenter(locationCoordinate, animated: true)
        
        if switchButton.isOn {
            let circle = MKCircle(center: locationCoordinate, radius: circleRadius)
            self.mapView.addOverlay(circle)
        } else {
            loadingSpinner.startAnimating()
            searchButton.setTitle("", for: .normal)
            
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]

                var fullAddress = ""
                
                if let streetNumber = placeMark.subThoroughfare{
                    fullAddress = "\(streetNumber) "
                }
                
                // Street address
                if let street = placeMark.thoroughfare {
                    fullAddress = "\(fullAddress)\(street), "
                }
                // City
                if let city = placeMark.locality {
                    fullAddress = "\(fullAddress)\(city), "
                }
                // Province
                if let province = placeMark.administrativeArea {
                    fullAddress = "\(fullAddress)\(province), "
                }
                
                // Country
                if let country = placeMark.country {
                    fullAddress = "\(fullAddress)\(country)"
                }
                
                let annotation = MKPointAnnotation()
                annotation.title = fullAddress
                annotation.coordinate = locationCoordinate
                self.mapView.addAnnotation(annotation)
                
                self.loadingSpinner.stopAnimating()
                self.searchButton.setTitle(fullAddress, for: .normal)
                
            })
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        
        return MKPolylineRenderer()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // handling code
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        updateLocation()
    }
    
    //Button listeners-----------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(fromChangeService){
                //delegate?.changeServiceLocation(latitude: latitude!, longitude: longitude!, circleDistance: circleRadius.radius)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                if switchButton.isOn{
                    createServiceModel.circleRadius = circleRadius
                } else {
                    createServiceModel.circleRadius = 0
                    createServiceModel.address = address
                }

                createServiceModel.location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let viewController = ServiceSchedulingController()
                viewController.createServiceModel = createServiceModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    @objc func switchChanged(sender: UISwitch) {
        updateLocation()
        if sender.isOn {
            plusButton.isHidden = false
            minusButton.isHidden = false
            searchButton.isHidden = true
        } else {
            plusButton.isHidden = true
            minusButton.isHidden = true
            searchButton.isHidden = false
        }
    }
    
    @objc func doneButton(sender: UIButton!) {
        switch sender {
        case plusButton:
            if circleRadius <= 16000 {
                self.circleRadius = circleRadius + 1000
                updateLocation()
            }
        case minusButton:
            if circleRadius >= 1000{
                self.circleRadius = circleRadius - 250
                updateLocation()
            }
        default:
            let viewController = GetUserLocationController()
            viewController.sendStringDelegate = self
            viewController.fromServiceLocation = true
            self.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    //Protocols---------------------
    
    func sendStringData(stringArray: [String]) {
        self.address = stringArray.first
        shouldUpdateMap = true
        getLocationFromAddress()
    }
    
}



