//
//  TextHelper.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 01/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit

open class TextHelper {
    
    open class func cleanString(body: String) -> String {
        
        var output = body
        
        output = output.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let _ = output.range(of: "<hr", options: .caseInsensitive) {
            output = output.replacingOccurrences(of: "<hr [^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
        
        output = output.replacingOccurrences(of: "<p>", with: "")
        output = output.replacingOccurrences(of: "</p>", with: "<br />")
        
        
        if (output.hasSuffix("<br />")) {
            if let range = output.range(of: "<br />", options: .backwards) {
                output.replaceSubrange(range, with: "")
            }
        }
        
        return output
    }
    
    open class func cleanStringIncludingParagraphBreaks(body: String) -> String {
        var output = body
        output = cleanString(body: output)
        output = output.replacingOccurrences(of: "<p><br></p>", with: "")
        return output
    }
    
    open class func flattenString(text: String) -> String{
        var output = text
        output = output.replacingOccurrences(of: "\n", with: "")
        output = output.replacingOccurrences(of: "<p>", with: " ")
        output = output.replacingOccurrences(of: "</p>", with: " ")
        output = output.replacingOccurrences(of: "<br>", with: " ")
        return output
    }
    
    open class func attributedTextForString(text: String) -> NSAttributedString {
        
        guard let htmlStringData = text.data(using: String.Encoding.utf8) else {
            return NSAttributedString(string: text)
        }
        
        do {
            let attributedHTMLString = try NSMutableAttributedString(data: htmlStringData, options: [.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let font = UIFont(name: "AvenirNext-Regular", size: 16)!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 0.0
            attributedHTMLString.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedHTMLString.length))
            return attributedHTMLString
            
        }catch{
            //Unable to format HTML body, in this scenario the raw html will be shown in the message cell
            return NSAttributedString(string: text)
        }
    }
    
    open class func wrapTextInHTML(text: String) -> String {
        
        let strippedString = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        let detector =  try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let range = strippedString.startIndex..<strippedString.endIndex
        //Get Range of test as Range
        let newRange = NSRange(range, in: strippedString)
        //Convert to NSRange for methods
        let matches = detector.matches(in: strippedString, options: [], range: newRange)
        
        var newStr = strippedString
        //Reversed so the ranges in strippedString will be ok to reference and wont need to be updates as we mutate values
        for match in matches.reversed() {
            //Convert back to swift Range
            if let swiftRange = Range(match.range, in: strippedString) {
                //Get URLString
                let urlString = String(strippedString[swiftRange])
                let hrefString: String
                
                //If we have http: before string leave it be otherwise prepend http://
                if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
                    hrefString = URL(string: urlString)?.absoluteString ?? urlString
                } else {
                    hrefString = URL(string: "http://\(urlString)")?.absoluteString ?? urlString
                }
                newStr = newStr.replacingCharacters(in: swiftRange, with: "<a href='\(hrefString)'>\(urlString)</a>")
            }
        }
        
        newStr = newStr.replacingOccurrences(of: "\n", with: "<br>")
        return newStr
    }
}

