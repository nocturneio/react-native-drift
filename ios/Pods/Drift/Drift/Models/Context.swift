//
//  Context.swift
//  Drift
//
//  Created by Brian McDonald on 08/12/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import Foundation
import ObjectMapper

class Context: Mappable {
    
    var userAgent: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userAgent   <- map["userAgent"]
    }
    
}
