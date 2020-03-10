//
//  UserScheduleModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-19.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation

class UserScheduleModel: NSObject {
    
    var startDate:Date?
    var endDate: Date?
    
    init(startDate:Date?, endDate:Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
