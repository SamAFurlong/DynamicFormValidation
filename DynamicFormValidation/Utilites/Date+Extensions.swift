//
//  Date+Extensions.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/19/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation

extension Date{
    var firestoreString:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
        
    }
    var hour:Int?{
        
        let component = Calendar.current.dateComponents([.hour], from: self)
        return component.hour
    }
    var minute:Int?{
        let component = Calendar.current.dateComponents([.minute], from: self)
        return component.hour
    }
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    func setTime(to hours: Int, and minutes:Int)->Date?{
        return Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: self)

    }
    
  
    
}
