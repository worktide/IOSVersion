//
//  AvailableDaysModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-11.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation

class AvailableDaysModel{
    
    var dayOfWeek:String?
    var startTime:String?
    var endTime:String?
    
    init(dayOfWeek:String?, startTime:String?, endTime:String?) {
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
    }
}
