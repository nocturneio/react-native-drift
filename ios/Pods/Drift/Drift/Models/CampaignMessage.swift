//
//  MessagePartData.swift
//  Driftt
//
//  Created by Eoin O'Connell on 22/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper
class CampaignMessage: Mappable {
    
    /**
        The type of message that the SDK can parse
        - Announcement: Announcement Campaign
     */
    enum MessageType: String {
        case Announcement = "ANNOUNCEMENT"
    }
    
    var orgId: Int?
    var id: Int?
    var uuid: String?
    var messageType: MessageType!
    var createdAt: Date?
    var bodyText: String?
    var authorId: Int64?
    var conversationId: Int?
    var viewerRecipientStatus: RecipientStatus?
    var announcementAttributes: AnnouncementAttributes?
    
    required convenience init?(map: Map) {
        if map.JSON["type"] as? String == nil || MessageType(rawValue: map.JSON["type"] as! String) == nil{
            LoggerManager.log(map.JSON["type"] as? String ?? "")
            return nil
        }
        
        self.init()
    }
    
    func mapping(map: Map) {
        orgId                   <- map["orgId"]
        id                      <- map["id"]
        uuid                    <- map["uuid"]
        messageType             <- map["type"]
        createdAt               <- (map["createdAt"], DateTransform())
        bodyText                <- map["body"]
        authorId                <- map["authorId"]
        conversationId          <- map["conversationId"]
        viewerRecipientStatus   <- map["viewerRecipientStatus"]
        
        if let messageType = messageType {
            switch messageType {
            case .Announcement:
                announcementAttributes <- map["attributes"]
            }
        }
    }
    
}
