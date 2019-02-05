//
//  UserManager.swift
//  Drift
//
//  Created by Eoin O'Connell on 17/08/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import UIKit

class UserManager {

    static let sharedInstance: UserManager = UserManager()
    
    var completionDict: [Int64: [((_ user: User?) -> ())]] = [:]
    var userCache: [Int64: (User)] = [:]

    func userMetaDataForUserId(_ userId: Int64, completion: @escaping (_ user: User?) -> ()) {
        if let user = userCache[userId] {
            completion(user)
        }else if let user = DriftDataStore.sharedInstance.embed?.users.filter({$0.userId == userId}).first {
            completion(user)
        }else{
            
            if let completionArr = completionDict[userId] {
                completionDict[userId] = completionArr + [completion]
            }else{
                completionDict[userId] = [completion]
                DriftAPIManager.getUser(userId, orgId: DriftDataStore.sharedInstance.embed!.orgId, authToken: DriftDataStore.sharedInstance.auth!.accessToken, completion: { (result) -> () in
                  
                    switch result {
                    case .success(let users):
                        
                        for user in users {
                            self.userCache[user.userId ?? userId] = user
                            self.executeCompletions(userId, user: user)
                        }
                        
                    case .failure(_):
                        self.executeCompletions(userId, user: nil)
                    }
                })
            }
        }
    }
    
    func executeCompletions(_ userId: Int64, user : User?) {
        if let completions = self.completionDict[userId] {
            for completion in completions {
                completion(user)
            }
        }
        completionDict[userId] = nil
    }
    
}
