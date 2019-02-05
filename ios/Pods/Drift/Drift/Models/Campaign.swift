//
//  Campaign.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 30/03/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit

import ObjectMapper
class Campaign: Mappable {
    
    var id: Int?
    
    required convenience init?(map: Map) {
        if map.JSON["id"] as? Int == nil{
            return nil
        }
        self.init()
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
    }
}
