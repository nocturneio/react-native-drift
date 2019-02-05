//
//  CampaignWrapper.swift
//  Drift
//
//  Created by Brian McDonald on 09/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import ObjectMapper

class CampaignWrapper: Mappable {
   
    var campaigns: [CampaignMessage]!
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        campaigns        <- map["messages"]
    }
    
}
