//
//  TimeRangeModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-26.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class TimeRangeModel:NSObject{
    
    var startDate: Date!
    var endDate: Date!
    
    init(startDate: Date, endDate: Date) {
        super.init()
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    

}
