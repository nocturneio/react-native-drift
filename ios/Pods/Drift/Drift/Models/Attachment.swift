//
//  Attachment.swift
//  Drift
//
//  Created by Brian McDonald on 29/07/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper
import Alamofire

class Attachment: Mappable, Hashable{
    var id = 0
    var fileName = ""
    var size = 0
    var data = Data()
    var mimeType = ""
    var conversationId = 0
    var publicId = ""
    var publicPreviewURL: String?
    
    func mapping(map: Map) {
        id                  <- map["id"]
        fileName            <- map["fileName"]
        size                <- map["size"]
        data                <- map["data"]
        mimeType            <- map["mimeType"]
        conversationId      <- map["conversationId"]
        publicId            <- map["publicId"]
        publicPreviewURL    <- map["publicPreviewUrl"]
    }
    
    var hashValue: Int {
        return id
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    open func isImage() -> Bool {
        return (mimeType.lowercased() ==  "image/jpeg") || (mimeType.lowercased() ==  "image/png") || (mimeType.lowercased() ==  "image/gif") || (mimeType.lowercased() ==  "image/jpg")
    }
    
    open func getAttachmentURL(accessToken: String?) -> URLRequest? {
        let headers: HTTPHeaders = [
            "Authorization": "bearer \(accessToken ?? "")"
        ]
        return try? URLRequest(url: URL(string: "https://conversation.api.drift.com/attachments/\(id)/data")!, method: .get, headers: headers)
    }
    
}

func ==(lhs: Attachment, rhs: Attachment) -> Bool {
    return lhs.id == rhs.id
}
