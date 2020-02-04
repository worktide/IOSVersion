//
//  ScheduleModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-19.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class ScheduleModel:NSObject{
    
    var bookDateDisplay:String?
    var bookDate:Date?
    var spotsAvailable:String?
    var timesAvailable = [String]()
    var shouldSelect = true
    
    init(availableDay:String?, startTime:String?, endTime:String?, serviceDuration:Int?, bookedSpots:[String], breakArray:[Date], timeRangeModel: [TimeRangeModel]) {
        
        //date calculation
        var day = Date.Weekday.monday
        switch availableDay {
        case "Monday":
            day = Date.Weekday.monday
        case "Tuesday":
            day = Date.Weekday.tuesday
        case "Wednesday":
            day = Date.Weekday.wednesday
        case "Thursday":
            day = Date.Weekday.thursday
        case "Friday":
            day = Date.Weekday.friday
        case "Saturday":
            day = Date.Weekday.saturday
        case "Sunday":
            day = Date.Weekday.sunday
        default:
            break
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let nextDate = Date.today().next(day, considerToday: true)
        
        //CHECK IF USER IS ON BREAK.
        var isBreakDay = false
        for date in breakArray{
            let dateInString = formatter.string(from: date)
            let selectedDate = formatter.string(from: nextDate)
            
            if(dateInString == selectedDate){
                isBreakDay = true
            }
        }
        
        if(isBreakDay){
            self.bookDateDisplay = availableDay! + ", " + formatter.string(from: nextDate)
            self.bookDate = nextDate
            self.spotsAvailable = "This user booked this day off."
            self.shouldSelect = false
        } else {
            self.bookDateDisplay = availableDay! + ", " + formatter.string(from: nextDate)
            self.bookDate = nextDate
            //Times Available Calculation
            ///10 minute intervals for each time slot
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            let dateFormatterDate = DateFormatter()
            dateFormatterDate.dateFormat = "MMMM d yyyy"
            
            //change array to date instead of string
            /*var bookedArray = [Date]()
            for bookedSpots in bookedSpots{
                bookedArray.append(dateFormatterDate.date(from: bookedSpots)!)
            }*/
            
            
            let startDateTime = dateFormatter.date(from: startTime!)!.round(to: 10, .minute)
            let endDateTime = dateFormatter.date(from: endTime!)!
            var array = [Date]()
            
            //change time of the date so we can compare
            let hourStart = Calendar.current.component(.hour, from: startDateTime)
            let minStart = Calendar.current.component(.minute, from: startDateTime)
            let hourEnd = Calendar.current.component(.hour, from: endDateTime)
            let minEnd = Calendar.current.component(.minute, from: endDateTime)
            
            var startDate = Calendar.current.date(bySettingHour: hourStart, minute: minStart, second: 0, of: nextDate)!
            let endDate = Calendar.current.date(bySettingHour: hourEnd, minute: minEnd, second: 0, of: nextDate)!
            
            while startDate < endDate {
                if(startDate < endDate){
                    array.append(startDate.round(to: 10, .minute))
                }
                startDate = startDate.addingTimeInterval(10 * 60.0)
               
            }
            
            ///REMOVE ANY TIMES THAT ARE BOOKED
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
            
            
            
            for date in array{
                let time = dateFormatter.string(from: date)
                timesAvailable.append(time)
            }
            
            //time slots available
            if(array.count == 0){
                self.spotsAvailable = "Booked out."
                self.shouldSelect = false
            } else {
                self.spotsAvailable = "\(array.count) time slots available"
            }
            
            
        
        }
        
    }
    
    
}
