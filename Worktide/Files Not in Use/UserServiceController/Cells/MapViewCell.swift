//
//  MapViewCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-08.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MapViewCell:UICollectionViewCell{
    
    var latitude:Double!
    var longitude:Double!
    var circleRadiusRange:Double!
    
    public let mapView:GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setMinZoom(10, maxZoom: mapView.maxZoom)
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.zoomGestures = false
        mapView.settings.scrollGestures = false
        mapView.layer.cornerRadius = 12
        mapView.isUserInteractionEnabled = false
        return mapView
    }()
    
    public let infoText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.text = "Tap the map for more info"
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        textView.numberOfLines = 0
        return textView
    }()
    
    public let marker:GMSMarker = {
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
        return circle
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mapView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        
        self.addSubview(infoText)
        infoText.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 5).isActive = true
        infoText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        mapView.camera = camera
        
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
        
        circleRadius.radius = circleRadiusRange
        circleRadius.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circleRadius.map = mapView
        
        if(circleRadiusRange != 0){
            let updatedCamera = GMSCameraUpdate.fit(circleRadius.bounds())
            mapView.animate(with: updatedCamera)
        }
    }
   

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
