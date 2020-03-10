//
//  CreateServiceModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-28.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import MapKit

class CreateServiceModel: NSObject {
    
    var serviceTitle:String?
    var variedPricing:Bool?
    var questionArray:[String]?
    var location:CLLocationCoordinate2D?
    var circleRadius:Double?
    var minimumPrice:Double?
    var maximumPrice:Double?
    var basePrice:Double?
    var estimatedDuration:Int?
    var scheduleArray:[String]?
    var serviceDescription:String?
    var noteToCustomer:String?
    var serviceImages:[UIImage]?
    var address:String?
}
