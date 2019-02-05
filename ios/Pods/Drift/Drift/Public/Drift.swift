//
//  File.swift
//  Driftt
//
//  Created by Eoin O'Connell on 21/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import Foundation

@objc
open class Drift: NSObject {

    
    /**
     Initialise Driftt SDK with an embed ID.
     
     - Parameter embedId: Embed ID found in Driftt Settings
     
    */
    @objc open class func setup(_ embedId: String) {
        DriftManager.retrieveDataFromEmbeds(embedId)
        DriftManager.createTemporaryDirectory()
    }
    
    /**
     Registers Users with drift. Should be completed after user login
    
     - Parameter userId: The User id from your database. Will be the same as on driftt.
     
    */
    @objc open class func registerUser(_ userId: String, email: String) {
        DriftManager.registerUser(userId, email: email, attrs: nil)
    }
    
    /**
     Logs users out of Drift
     */
    @objc open class func logout() {
        DriftManager.logout()
    }
    
    /**

     This mode enables you to see the output logs of drift for debug purposes
     This will also stop dismissing announcements from being sticky so you can see the same announcement over and over
     
     - parameter debug: A Bool indicating if debug mode should be enabled or not
     
    */
    @objc open class func debugMode(_ debug:Bool) {
        DriftManager.debugMode(debug)
    }
    
    /**
     
     This allows you to force that only active campaigns will be shown to users and not inactive or archived campaigns

     - parameter debug: A Bool indicating if archived campaigns should shown to the user
     
     */
    @objc open class func showArchivedCampaignsForEndUser(_ show:Bool) {
        DriftManager.showArchivedCampaigns(show)
    }
    
    /**

     This will show a list of Drift conversations for the current user
     
     */
    @objc open class func showConversations() {
        DriftManager.showConversations()
    }
    
    /**
     
     This will show create viewcontroller with option for back arrow to
     
     */
    @objc open class func showCreateConversation() {
        DriftManager.showCreateConversation()
    }
}
