//
//  BookingsModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-11.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation

class BookingsModel:NSObject{
    
    var bookDateDisplay:String?
    var bookDate:Date?
    var spotsAvailable:String?
    var timesAvailable = [String]()
    
    
    init(availableDay:Date?, availableDaysModel: [AvailableDaysModel],timeRangeModel: [TimeRangeModel], serviceDuration:Int?) {
        self.bookDate = availableDay
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"

        self.bookDateDisplay = formatter.string(from: availableDay!)
        
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEEE"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        var startTime = ""
        var endTime = ""
        for day in availableDaysModel{
            if(day.dayOfWeek == dayOfWeekFormatter.string(from: availableDay!)){
                startTime = day.startTime!
                endTime = day.endTime!
            }
        }
        
        let startDateTime = timeFormatter.date(from: startTime)!.round(to: 10, .minute)
        let endDateTime = timeFormatter.date(from: endTime)!
        var array = [Date]()
        
        //change time of the date so we can compare
        let hourStart = Calendar.current.component(.hour, from: startDateTime)
        let minStart = Calendar.current.component(.minute, from: startDateTime)
        let hourEnd = Calendar.current.component(.hour, from: endDateTime)
        let minEnd = Calendar.current.component(.minute, from: endDateTime)
        
        var startDate = Calendar.current.date(bySettingHour: hourStart, minute: minStart, second: 0, of: availableDay!)!
        let endDate = Calendar.current.date(bySettingHour: hourEnd, minute: minEnd, second: 0, of: availableDay!)!
        
        while startDate < endDate {
            if(startDate < endDate){
                array.append(startDate.round(to: 10, .minute))
            }
            startDate = startDate.addingTimeInterval(10 * 60.0)
        }
        
        ///remove any times thar are booked
        var x = 0
        for date in array{
            innerLoop: for times in timeRangeModel{
                let timeStart = times.startDate
                let timeEnd = times.endDate!
                
                if(date.isBetween(timeStart! - 60, and: timeEnd - 60)){
                    //remove these values
                    array.remove(at: x)
                    x -= 1
                    break innerLoop //done checking this time move on to next
                } else {
                    //if date is not between service times
                    //check if time gap is big enough
                    if(date.addingTimeInterval(Double(serviceDuration!) * 60) > timeStart! && date < timeStart!){
                        array.remove(at: x)
                        x -= 1
                        break innerLoop //done checking this time move on to next
                    }
                }
            }
            x += 1
        }
        
        ///remove any times that have passed
        array = array.filter {$0 > Date()}
        
        
        for date in array{
            let time = timeFormatter.string(from: date)
            timesAvailable.append(time)
        }
        
        //time slots available
        if(array.count == 0){
            self.spotsAvailable = "Booked out."
        } else {
            self.spotsAvailable = "\(array.count) time slots available"
        }

    }
}
