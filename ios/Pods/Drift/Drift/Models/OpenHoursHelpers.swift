//
//  OpenHoursHelpers.swift
//  Drift
//
//  Created by Brian McDonald on 15/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import UIKit

class OpenHoursHelpers {
    
    class func getWeekDayFromDate(date: Date, timezone: TimeZone) -> Int{
        var calendar = Calendar.current
        calendar.timeZone = timezone
        return calendar.component(.weekday, from: date)
    }
    
    class func convertStringForDate(dateString: String, timezone: TimeZone) -> Date?{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.timeZone = timezone
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        if let date = dateFormat.date(from: dateString){
            let dateComponents = calendar.dateComponents(in: timezone, from: date)
            return calendar.date(bySettingHour:  dateComponents.hour!, minute: dateComponents.minute!, second: dateComponents.second!, of: Date())
        }
        
        return nil
    }
    
}

