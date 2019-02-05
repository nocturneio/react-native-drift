//
//  AppointmentInformation.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 07/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit
import ObjectMapper

class AppointmentInformation: Mappable{
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    var availabilitySlot = Date()
    var slotDuration = -1
    var agentId: Int64 = -1
    var conversationId = -1
    var endUserTimeZone: String?
    var agentTimeZone: String?
    
    open func mapping(map: Map) {
        
        availabilitySlot    <- (map["availabilitySlot"], DriftDateTransformer())
        slotDuration        <- map["slotDuration"]
        agentId             <- map["agentId"]
        conversationId      <- map["conversationId"]
        endUserTimeZone     <- map["endUserTimeZone"]
        agentTimeZone       <- map["agentTimeZone"]
    }
}

