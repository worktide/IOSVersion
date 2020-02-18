//
//  ServicerAppointmentsModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

class ServicerAppointmentsModel: NSObject {
    
    var bookingID:String?
    var serviceTitle:String?
    var otherName:String?
    var servicePrice:String?
    var serviceDate:Date?
    var serviceTime:String?
    var serviceDuration:String?
    var serviceLocationText:String?
    var serviceLocation:CLLocation?
    var userPhoneNumber:String?
    
    init(bookingID:String?, serviceTitle:String?, otherName:String?, otherPhoneNumber:String?, servicePrice:String?, startDate:Date?, endDate: Date?, serviceAddress:String?, location: CLLocation?) {
        super.init()
        self.bookingID = bookingID
        self.serviceTitle = serviceTitle
        self.otherName = otherName
        self.servicePrice = servicePrice
        self.serviceDate = startDate
        self.serviceLocation = location
        self.userPhoneNumber = otherPhoneNumber
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        serviceTime = dateFormatter.string(from: startDate!)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .full
        self.serviceDuration = formatter.string(from: startDate!, to: endDate!)
        
        if serviceAddress == nil {
            self.serviceLocationText = "Click options to open in maps"
        } else {
            self.serviceLocationText = serviceAddress
        }
        
        
    }
}
