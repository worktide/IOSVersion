//
//  AppointmentsModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-27.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class AppointmentsModel:NSObject{
   
    var serviceTitle: String?
    var servicePrice:String?
    var serviceDateDisplay:String?
    var serviceDate:Date?
    var otherName:String?
    var otherUserImage:UIImage?
    var circleRadius:Double?
    var latitude:Double?
    var longitude:Double?
    var usersPhoneNumber:String?
    var bookingID:String?
    var customerID:String?
    
    
    init(serviceTitle:String?, servicePrice: String?, startDate:Date?, otherName:String?, userImage:UIImage?, circleRadius:Double, latitude:Double, longitude: Double, usersPhoneNumber:String?, bookingID:String?, customerID:String?){
        super.init()
        self.serviceTitle = serviceTitle
        self.servicePrice = servicePrice
        self.serviceDate = startDate
        self.otherName = otherName
        self.otherUserImage = userImage
        self.circleRadius = circleRadius
        self.latitude = latitude
        self.longitude = longitude
        self.usersPhoneNumber = usersPhoneNumber
        self.bookingID = bookingID
        self.customerID = customerID
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd @ hh:mm a"
        self.serviceDateDisplay = formatter.string(from: startDate!)
        
    }
    
    

}
