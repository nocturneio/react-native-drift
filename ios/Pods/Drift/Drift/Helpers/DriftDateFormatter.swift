//
//  DriftDateFormatter.swift
//  Conversations
//
//  Created by Brian McDonald on 16/05/2016.
//  Copyright © 2016 Drift. All rights reserved.
//


class DriftDateFormatter: DateFormatter {
    
    func createdAtStringFromDate(_ date: Date) -> String{
        dateFormat = "HH:mm"
        timeStyle = .short
        return string(from: date)
    }
    
    func updatedAtStringFromDate(_ date: Date) -> String{
        let now = Date()
        if (Calendar.current as NSCalendar).component(.day, from: date) != (Calendar.current as NSCalendar).component(.day, from: now){
            dateStyle = .short
        }else{
            dateFormat = "H:mm a"
        }
        return string(from: date)
    }
    
    func headerStringFromDate(_ date: Date) -> String{
        let now = Date()
        if (Calendar.current as NSCalendar).component(.day, from: date) != (Calendar.current as NSCalendar).component(.day, from: now){
            dateFormat = "MMMM d"
        }else{
            return "Today"
        }
        return string(from: date)
    }
    
    func dateFormatForMeetings(date: Date) -> String {
        dateFormat = "EEEE, MMMM dd, YYYY"
        return string(from: date)
    }
    
}
