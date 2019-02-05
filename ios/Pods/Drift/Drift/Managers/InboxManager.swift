//
//  InboxManager.swift
//  Drift
//
//  Created by Brian McDonald on 25/07/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper

class InboxManager {
    static let sharedInstance: InboxManager = InboxManager()
    let pageSize = 30
    
    
    func getMessages(_ conversationId: Int, completion:@escaping (_ messages: [Message]?) -> ()){
        guard let auth = DriftDataStore.sharedInstance.auth?.accessToken else {
            LoggerManager.log("No Auth Token for Recording")
            return
        }
        
        DriftAPIManager.getMessages(conversationId, authToken: auth) { (result) in
            switch result{
            case .success(let messages):
                completion(messages)
            case .failure:
                LoggerManager.log("Unable to retreive messages for conversationId: \(conversationId)")
                completion(nil)
            }
        }
    }
    
    func postMessage(_ messageRequest: MessageRequest, conversationId: Int, completion:@escaping (_ message: Message?, _ requestId: Double) -> ()){

        DriftAPIManager.postMessage(conversationId, messageRequest: messageRequest) { (result) in
            switch result{
            case .success(let returnedMessage):
                completion(returnedMessage, messageRequest.requestId)
            case .failure:
                LoggerManager.log("Unable to post message for conversationId: \(conversationId)")
                completion(nil, messageRequest.requestId)
            }
        }
    }
    
    
    func createConversation(_ messageRequest: MessageRequest, welcomeMessageUser: User?, welcomeMessage: String?, completion:@escaping (_ message: Message?, _ requestId: Double) -> ()){
        guard let auth = DriftDataStore.sharedInstance.auth?.accessToken else {
            LoggerManager.log("No Auth Token for Recording")
            return
        }
        
        DriftAPIManager.createConversation(messageRequest.body , welcomeUserId: welcomeMessageUser?.userId, welcomeMessage: welcomeMessage, authToken: auth) { (result) in
            switch result{
            case .success(let returnedMessage):
                completion(returnedMessage, messageRequest.requestId)
            case .failure:
                LoggerManager.log("Unable to create conversation")
                completion(nil, messageRequest.requestId)
            }
        }
    }
}

