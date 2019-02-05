//
//  SocketAuth.swift
//  Drift
//
//  Created by Eoin O'Connell on 31/05/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import UIKit
import ObjectMapper

class SocketAuth: Mappable {
    
    var sessionToken: String = ""
    var userId: String = ""
    var orgId: Int = -1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userId          <- map["user_id"]
        sessionToken    <- map["session_token"]
        orgId           <- map["org_id"]
    }
    
}
