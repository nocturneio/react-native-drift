//
//  User.swift
//  Drift
//
//  Created by Eoin O'Connell on 25/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper
///User obect - Attached to Auth and used to make sure user has not changed during app close
class User: Mappable, Equatable {
    
    var userId: Int64?
    var orgId: Int?
    var email: String?
    var name: String?
    var externalId: String?
    var avatarURL: String?
    var bot = false

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userId      <- map["id"]
        email       <- map["email"]
        orgId       <- map["orgId"]
        name        <- map["name"]
        externalId  <- map["externalId"]
        avatarURL   <- map["avatarUrl"]
        bot         <- map["bot"]
    }
    func getUserName() -> String{
        return name ?? email ?? "No Name Set"
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.userId == rhs.userId
}
