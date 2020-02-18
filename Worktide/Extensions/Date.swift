//
//  Date.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-19.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

extension Date {
    
    /// Returns date where **-component** is rounded to its closest
    /// multiple of **-amount**. Warning: month and day start at 1
    /// so round(to: 6, .month) will either return month 1 or 7!
    func round(to amount: Int, _ component: Calendar.Component) -> Date {
        let cal = Calendar.current
        var value = cal.component(component, from: self)
        
        if [.month, .day].contains(component) {
            // Months and days start at 1, time/year starts at 0
            value -= 1
        }
        
        // Compute nearest multiple of amount
        let fraction = Double(value) / Double(amount)
        let roundedValue = Int(fraction.rounded()) * amount
        let newDate = cal.date(byAdding: component, value: roundedValue - value, to: self)!
        
        return newDate.floorAllComponents(before: component)
    }
    
    /// Returns date where all components before paramater are set to
    /// their beginning value; day and month to 1 and everything else
    /// to 0
    func floorAllComponents(before component: Calendar.Component) -> Date {
        // All components to round ordered by length
        let components = [Calendar.Component.year, .month, .day, .hour, .minute, .second, .nanosecond]
        
        guard let index = components.firstIndex(of: component) else {
            fatalError("Wrong component")
        }
        
        let cal = Calendar.current
        var date = self
        
        components.suffix(from: index + 1).reversed().forEach { roundComponent in
            var value = cal.component(roundComponent, from: date) * -1
            if [.month, .day].contains(roundComponent) {
                // Months and days start at 1, time/year starts at 0
                value += 1
            }
            date = cal.date(byAdding: roundComponent, value: value, to: date)!
        }
        
        return date
    }
    
    init?(_ string: String, format: String) {
        guard let date = DateFormatter(format).date(from: string) else {
            return nil
        }
        self = date
    }
}

extension DateFormatter {
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        timeZone = Calendar.current.timeZone
        locale = Calendar.current.locale
    }
    
    convenience init(date: Style, time: Style) {
        self.init()
        dateStyle = date
        timeStyle = time
        timeZone = Calendar.current.timeZone
        locale = Calendar.current.locale
    }
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {

    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }

    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }

}


