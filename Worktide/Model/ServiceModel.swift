//
//  ServiceModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-18.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class ServiceModel:NSObject{
   
    var serviceTitle: String?
    var servicePay: String?
    var serviceID:String?
    
    init(serviceTitle:String?, servicePay:String?, serviceID:String?) {
        self.serviceTitle = serviceTitle
        self.servicePay = servicePay
        self.serviceID = serviceID
    }

}
