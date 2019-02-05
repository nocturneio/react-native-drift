//
//  GoogleMeeting.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 07/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit
import ObjectMapper

class GoogleMeeting: Mappable {

    
    var startTime:Date?
    var endTime:Date?
    var meetingId: String?
    var meetingURL: String?
    
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    open func mapping(map: Map) {
        
        /*
 
         {
         "id": "7o1moushcep01cctkeeos0nlo4",
         "start": 1517994000000,
         "end": 1517995800000,
         "attendees": [
         "eoin+app@8bytes.is",
         "eoin+testing@8bytes.ie"
         ],
         "summary": "Eoin Test Accounting & Eoin O'Connell (8bytes) - New Meeting",
         "location": null,
         "description": "Book meetings faster with Drift\nhttp://drift.com/meetings",
         "url": "https://www.google.com/calendar/event?eid=N28xbW91c2hjZXAwMWNjdGtlZW9zMG5sbzQgZW9pbkA4Ynl0ZXMuaWU"
         }
         
         */
        
        startTime           <- (map["start"], DriftDateTransformer())
        endTime             <- (map["end"], DriftDateTransformer())
        meetingId           <- map["id"]
        meetingURL          <- map["url"]
    }
    
}
