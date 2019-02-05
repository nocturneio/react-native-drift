//
//  AlertManager.swift
//  Drift
//
//  Created by Eoin O'Connell on 22/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import Foundation

class CampaignsManager {

    class func checkForCampaigns(userId: Int64, embed: Embed) {
        DriftAPIManager.getCampaigns(userId) { (result) in
            switch result {
            case .success(let campaignWrappers):
                var campaigns: [CampaignMessage] = []
                for campaignWrapper in campaignWrappers {
                    campaigns.append(contentsOf: campaignWrapper.campaigns)
                }
                let filteredCampaigns = filtercampaigns(campaigns, embed: embed)
                PresentationManager.sharedInstance.didRecieveCampaigns(filteredCampaigns)
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }
    
    /**
        This is responsible for filtering an array of campaigns into Announcements
        This will also filter out non presentable campaigns
        - parameter campaign: Array of non filtered campaigns
        - returns: Announcement Type Campaigns that are presentable in SDK
    */
    class func filtercampaigns(_ campaigns: [CampaignMessage], embed: Embed) -> [CampaignMessage] {
        
        ///DO Priority - Announcements, Latest first
        
        let activeCampaignIds: [Int] = embed.activeCampaigns.compactMap({ $0.id })
        
        var announcements: [CampaignMessage] = []
        
        for campaign in campaigns {
            
            if campaign.viewerRecipientStatus != .Read {
                switch campaign.messageType {
                    
                case .some(.Announcement):
                    
                    guard let campaignId = campaign.announcementAttributes?.campaignId else {
                        LoggerManager.log("No campaign Id set on announcment campaign")
                        continue
                    }
                    
                    if !DriftManager.sharedInstance.showArchivedCampaigns && !activeCampaignIds.contains(campaignId) {
                        LoggerManager.log("Not showing campaign as not currently active in embed")
                        continue
                    }
                    
                    //Only show chat response announcements if we have an email
                    if let ctaType = campaign.announcementAttributes?.cta?.ctaType , ctaType == .ChatResponse{
                        if let email = DriftDataStore.sharedInstance.embed?.inboxEmailAddress , email != ""{
                            announcements.append(campaign)
                        }else{
                            LoggerManager.log("Did remove chat announcement as we dont have an email")
                        }
                    }else{
                        announcements.append(campaign)
                    }
                default:
                    ()
                }
            }
        }
        
        return announcements
    }
    
    class func markCampaignAsRead(_ messageId: Int) {
        DriftAPIManager.markMessageAsRead(messageId: messageId) { (result) in
            switch result {
            case .success:
                LoggerManager.log("Successfully marked Campaign Read: \(messageId)")
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }
    
}
