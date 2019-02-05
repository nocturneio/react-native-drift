//
//  ConversationsManager.swift
//  Drift
//
//  Created by Brian McDonald on 08/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import Foundation

class ConversationsManager {
    
    class func checkForConversations(userId: Int64) {
        DriftAPIManager.getEnrichedConversations(userId) { (result) in
            switch result {
            case .success(let conversations):
                let conversationsToShow = conversations.filter({$0.unreadMessages > 0})
                PresentationManager.sharedInstance.didRecieveNewMessages(conversationsToShow)
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }
    
    class func markMessageAsRead(_ messageId: Int) {
        DriftAPIManager.markConversationAsRead(messageId: messageId) { (result) in
            switch result {
            case .success:
                LoggerManager.log("Successfully marked Message Read: \(messageId)")
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }

}
