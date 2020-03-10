//
//  UserAvailabilityModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-19.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class UserAvailabilityModel: NSObject {
    
    let startTimeHour:Int
    let startTimeMin:Int
    let endTimeHour:Int
    let endTimeMin:Int
    let dayOfWeek:Int //sunday = 1, monday = 2 .....
    
    init(dayOfWeekString:String?, startTimeString:String?, endTimeString:String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let date = dateFormatter.date(from: dayOfWeekString!)!
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: date)
        self.dayOfWeek = components.weekday!
        
        
        dateFormatter.dateFormat = "hh:mm a"
        let startDate = dateFormatter.date(from: startTimeString!)
        let endDate = dateFormatter.date(from: endTimeString!)
        
        self.startTimeHour = Calendar.current.component(.hour, from: startDate!)
        self.startTimeMin = Calendar.current.component(.minute, from: startDate!)
        
        self.endTimeHour = Calendar.current.component(.hour, from: endDate!)
        self.endTimeMin = Calendar.current.component(.minute, from: endDate!)
        
    }
}
