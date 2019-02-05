//
//  DriftDateTransformer.swift
//  Conversations
//
//  Created by Brian McDonald on 16/05/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper

class DriftDateTransformer: TransformType{

    typealias Object = Date
    typealias JSON = Double
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt/1000))
        }
        
        if let timeStr = value as? String {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)/1000))
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970*1000)
        }
        return nil
    }
    
}
