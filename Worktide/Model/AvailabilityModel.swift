//
//  AvailabilityModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-10.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class AvailabilityModel:NSObject{
   
    var dayOfWeek: String?
    var startTime: String?
    var endTime: String?
    
    init(dayOfWeek: String?, startTime: String?, endTime:String?) {
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
    }

}

