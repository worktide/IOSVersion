//
//  HelperForCalculating.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-19.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation

class HelperForCalculating {
    
    static func setupNext90Days() -> [Date] {
        var next90DaysArray = [Date]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for _ in 1 ... 90 {
            next90DaysArray.append(date)
            date = cal.date(byAdding: .day, value: +1, to: date)!
        }
        return next90DaysArray
    }
    
    static func calculateAvailableDays(next90Days:[Date], userAvailabilityModel: [UserAvailabilityModel]) -> [UserScheduleModel] {
        
        let calendar = Calendar(identifier: .gregorian)
        var userScheduleModelArr = [UserScheduleModel]()
        var availableDays = [Date]()
        
        for day in next90Days {
            let components = calendar.dateComponents([.weekday], from: day)
            let weekday = components.weekday
            
            if userAvailabilityModel.contains(where: { $0.dayOfWeek == weekday }) {
                availableDays.append(day)
            }
        }
        
        for day in availableDays {
            let components = calendar.dateComponents([.weekday], from: day)
            
            let model = userAvailabilityModel.first(where: { $0.dayOfWeek == components.weekday})
            let startDate = Calendar.current.date(bySettingHour: model!.startTimeHour, minute: model!.startTimeMin, second: 0, of: day)!
            let endDate = Calendar.current.date(bySettingHour: model!.endTimeHour, minute: model!.endTimeMin, second: 0, of: day)!
            
            userScheduleModelArr.append(UserScheduleModel(startDate: startDate, endDate: endDate))
        }
        
        return userScheduleModelArr
        
    }
    
    
}
