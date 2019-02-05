//
//  UserAvailability.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 05/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import ObjectMapper

class UserAvailability: Mappable {

    
    var duration: Int?
    var timezone: String = ""
    var slots: [Date]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        duration            <- map["slotDuration"]
        timezone            <- map["agentTimezone"]
        slots               <- (map["slots"], DriftDateTransformer())
    }
    
    func slotsForDays() -> [Date] {

        
        let days: [Date] = (slots ?? []).compactMap({
            let components = Calendar.current.dateComponents([.year, .month, .day], from: $0)
            return Calendar.current.date(from: components)
        })
        
        return Array(Set(days)).sorted(by: { $0 < $1 })
    }
    
    func slotsForDay(date: Date) -> [Date] {
        
        let selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)

        
        let times: [Date] = (slots ?? []).filter({
            let components = Calendar.current.dateComponents([.year, .month, .day], from: $0)

            return  components.year == selectedDateComponents.year &&
                    components.month == selectedDateComponents.month &&
                    components.day == selectedDateComponents.day
        })
        
        return times.sorted(by: { $0 < $1 })
    }
    
}
