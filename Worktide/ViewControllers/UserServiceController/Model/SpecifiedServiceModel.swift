//
//  SpecifiedServiceModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-14.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import MapKit

class SpecifiedServiceModel:NSObject{
   
    var serviceTitle: String?
    var servicePayString: String?
    var serviceID:String?
    var locationDistance:String?
    var durationString:String?
    var userInRange:Bool = true
    var latitude: Double?
    var longitude: Double?
    var circleRadius: Double?
    var serviceDuration:Int?
    var jobDescription:String?
    
    
    init(serviceTitle:String?, servicePay:String?, serviceID:String?, latitude: Double?, longitude: Double?, circleRadius:Double?, currentLocation:CLLocationCoordinate2D?, duration:Int?, jobDescription: String?) {
        super.init()
        self.serviceTitle = serviceTitle
        self.servicePayString = "$" + servicePay!
        self.serviceID = serviceID
        self.latitude = latitude
        self.longitude = longitude
        self.circleRadius = circleRadius
        self.serviceDuration = duration
        self.jobDescription = jobDescription
        
        if(currentLocation != nil){
            //determine location of service
            let serviceLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            if(circleRadius == 0){
                //if the service is a shop
                let distanceApart = currentLocation!.distance(from: serviceLocation)
                self.locationDistance = "\(String(format:"%.2f", Double(distanceApart)/1000)) km away from you"
            } else {
                //service is location based
                let distanceApart = currentLocation!.distance(from: serviceLocation)
                if(Double(distanceApart).isLess(than: circleRadius!)){
                    //user inside of circle
                    self.userInRange = true
                    self.locationDistance = "This service will come to you."
                } else {
                    //user is outside of circle
                    self.userInRange = false
                    self.locationDistance = "This service is not available in your location."
                }
            }
        } else {
            self.userInRange = false
            self.locationDistance = "Finish setting up your account to book."
        }
        
        
        //change string of time
        let time = minutesToHoursMinutes(minutes: duration!)
        let hour = time.hours
        let minutes = time.leftMinutes
        //set text
        if(hour == 0){
            self.durationString = String(minutes) + " min"
        } else {
            if(hour == 1){
                self.durationString = String(hour) + " hour " + String(minutes) + " min"
            } else {
                self.durationString = String(hour) + " hours " + String(minutes) + " min"
            }
        }
        
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    

}
