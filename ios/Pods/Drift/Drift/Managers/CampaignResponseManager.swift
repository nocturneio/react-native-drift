//
//  CampaignResponseManager.swift
//  Drift
//
//  Created by Eoin O'Connell on 03/02/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

enum CampaignResponse{
    case announcement(AnnouncementResponse)
}

enum AnnouncementResponse: String {
    case Opened = "OPENED"
    case Dismissed = "DISMISSED"
    case Clicked = "CLICKED"
}

class CampaignResponseManager {
    
    class func recordAnnouncementResponse(_ campaign: CampaignMessage, response: AnnouncementResponse){
        
        LoggerManager.log("Recording Announcement Response:\(response) \(String(describing: campaign.conversationId)) ")

        guard let auth = DriftDataStore.sharedInstance.auth?.accessToken else {
            LoggerManager.log("No Auth Token for Recording")
            return
        }
        
        guard let conversationId = campaign.conversationId else{
            LoggerManager.log("No Conversation Id in campaign")
            return
        }
        
        if let id = campaign.id, !DriftManager.sharedInstance.debug{
            CampaignsManager.markCampaignAsRead(id)
        }
        
        if !DriftManager.sharedInstance.debug {
            DriftAPIManager.recordAnnouncement(conversationId, authToken: auth, response: response)
        }
    }
    
}
