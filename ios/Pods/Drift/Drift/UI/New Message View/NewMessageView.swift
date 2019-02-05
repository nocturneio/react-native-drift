//
//  NotificationView.swift
//  Drift
//
//  Created by Eoin O'Connell on 26/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import UIKit
import SafariServices

class NewMessageView: CampaignView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var notificationContainer: UIView!
    @IBOutlet weak var notificationCountlabel: UILabel!
    @IBOutlet weak var bottomButtonColourView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    
    var bottomConstraint: NSLayoutConstraint!
    var message: Message! {
        didSet{
            setupForConversation()
        }
    }
    var otherConversations: [EnrichedConversation] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 4
        userImageView.contentMode = .scaleAspectFill
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5
        notificationContainer.isHidden = true
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.cornerRadius = 6
    }
    
    func setupForConversation() {
        let background = DriftDataStore.sharedInstance.generateBackgroundColor()
        let foreground = DriftDataStore.sharedInstance.generateForegroundColor()

        bottomButtonColourView.backgroundColor = background
        dismissButton.setTitleColor(foreground, for: UIControl.State())
        openButton.setTitleColor(foreground, for: UIControl.State())
        
        var userId: Int64?
        if otherConversations.isEmpty {
            //Setup for latest message in conversation
            notificationContainer.isHidden = true
            titleLabel.text = "New Message"
            
            if message.attachmentIds.count > 0{
                infoLabel.text = "📎 [Attachment]"
            }else{
                do {
                    let htmlStringData = (message?.body ?? "").data(using: String.Encoding.utf8)!
                    let attributedHTMLString = try NSMutableAttributedString(data: htmlStringData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                    infoLabel.text = attributedHTMLString.string
                } catch {
                    infoLabel.text = message?.body ?? ""
                }
            }

            userId = message?.authorId
            
        }else{
            //Setup for new messages 
            notificationCountlabel.text = "\(otherConversations.count + 1)"
            notificationCountlabel.layer.cornerRadius = notificationCountlabel.frame.size.width / 2
            notificationCountlabel.clipsToBounds = true
            notificationContainer.layer.cornerRadius = notificationContainer.frame.size.width / 2
            notificationContainer.clipsToBounds = true
            notificationContainer.isHidden = false
            
            
            titleLabel.text = "New Messages"
            infoLabel.text = "Click below to open"
            
            userImageView.isHidden = true
        }
        
        if let userId = userId {            
            UserManager.sharedInstance.userMetaDataForUserId(userId, completion: { (user) in
                if let user = user {
                    if let avatar = user.avatarURL, let url = URL(string: avatar) {
                        self.userImageView.af_setImage(withURL: url)
                    }
                    self.titleLabel.text = user.name ?? "New Message"
                }
            })
        }
    }
    
    override func showOnWindow(_ window: UIWindow) {
        window.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1.0, constant: window.frame.size.width)
        window.addConstraint(leading)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1.0, constant: window.frame.size.width)
        window.addConstraint(trailing)
        
        var bottomConstant: CGFloat = -15.0
        if TopController.hasTabBar() {
            bottomConstant = -65.0
        }
        
        if #available(iOS 11.0, *) {
            bottomConstant = bottomConstant - window.safeAreaInsets.bottom
        }
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1.0, constant: bottomConstant)
        
        window.addConstraint(bottomConstraint)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110.0))
        window.layoutIfNeeded()
        leading.constant = 0
        trailing.constant = 0
        window.setNeedsUpdateConstraints()
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            window.layoutIfNeeded()
        }, completion:nil)
    }
    
    override func hideFromWindow() {
        bottomConstraint.constant = 130
        setNeedsLayout()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            self.backgroundColor = UIColor(white: 1, alpha: 0.5)
            self.layoutIfNeeded()
        }, completion: nil)

    }
    
    @IBAction func skipPressed(_ sender: AnyObject) {
        markAllAsRead()
        delegate?.messageViewDidFinish(self)
    }
    
    @IBAction func readPressed(_ sender: AnyObject) {
        delegate?.messageViewDidFinish(self)
        markAllAsRead()
        if otherConversations.isEmpty {
            PresentationManager.sharedInstance.showConversationVC(message.conversationId)
        }else{
            if let endUserId = DriftDataStore.sharedInstance.auth?.enduser?.userId{
                PresentationManager.sharedInstance.showConversationList(endUserId: endUserId)
            }
        }
    }
    
    func markAllAsRead(){
        for conversation in otherConversations {
            if let msgId = conversation.lastMessage?.id {
                ConversationsManager.markMessageAsRead(msgId)
            }
        }
        
        ConversationsManager.markMessageAsRead(message.id)
    }
    
}
