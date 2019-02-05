//
//  EnrichedConversation.swift
//  Drift
//
//  Created by Brian McDonald on 08/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import ObjectMapper

class EnrichedConversation: Mappable {
    
    var conversation: Conversation!
    var unreadMessages: Int = 0
    var lastMessage: Message?
    var lastAgentMessage: Message?
    
    required convenience init?(map: Map) {
        if let conversationJSON = map.JSON["conversation"] as? [String: Any], conversationJSON["type"] as? String == "EMAIL"{
            return nil
        }
        self.init()
    }
    
    
    func mapping(map: Map) {
        conversation        <- map["conversation"]
        unreadMessages      <- map["unreadMessages"]
        lastMessage         <- map["lastMessage"]
        lastAgentMessage    <- map["lastAgentMessage"]
    }

}
