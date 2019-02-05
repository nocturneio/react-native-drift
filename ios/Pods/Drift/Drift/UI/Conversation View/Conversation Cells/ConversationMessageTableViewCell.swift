//
//  ConversationMessageTableViewCell.swift
//  Drift
//
//  Created by Brian McDonald on 01/08/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import UIKit
import AlamofireImage

class ConversationMessageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var attachmentsCollectionView: UICollectionView!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var attachmentImageView: UIImageView!

    @IBOutlet weak var attachmentContainerView: UIView!
    @IBOutlet weak var singleAttachmentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var multipleAttachmentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var singleAttachmentView: UIView!
    
    @IBOutlet weak var multipleAttachmentView: UIView!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: MessageTableHeaderView!
    
    @IBOutlet var scheduleMeetingHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var scheduleMeetingAvatarView: AvatarView!
    @IBOutlet var scheduleMeetingLabel: UILabel!
    @IBOutlet var scheduleMeetingButton: UIButton!
    @IBOutlet var scheduleMeetingBorderView: UIView!
    
    enum AttachmentStyle {
        case single
        case multiple
        case loading
        case none
    }
    
    lazy var dateFormatter: DriftDateFormatter = DriftDateFormatter()

    var indexPath: IndexPath?
    var message: Message?
    var configuration: Embed?
    weak var delegate: ConversationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.textColor = ColorPalette.navyDark
        nameLabel.isUserInteractionEnabled = true
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets.zero
        selectionStyle = .none
        attachmentsCollectionView.register(UINib.init(nibName: "AttachmentCollectionViewCell", bundle: Bundle(for: AttachmentCollectionViewCell.classForCoder())), forCellWithReuseIdentifier: "AttachmentCollectionViewCell")
        attachmentsCollectionView.dataSource = self
        attachmentsCollectionView.delegate = self
        attachmentsCollectionView.backgroundColor = UIColor.white
        
        
        scheduleMeetingBorderView.layer.borderWidth = 1
        scheduleMeetingBorderView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        scheduleMeetingBorderView.layer.cornerRadius = 3
        
        scheduleMeetingButton.layer.cornerRadius = 3
        scheduleMeetingButton.backgroundColor = DriftDataStore.sharedInstance.generateBackgroundColor()
        scheduleMeetingButton.setTitleColor(DriftDataStore.sharedInstance.generateForegroundColor(), for: .normal)
        loadingContainerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        loadingContainerView.layer.cornerRadius = 6
        loadingContainerView.clipsToBounds = true
        loadingContainerView.alpha = 0
        attachmentImageView.layer.masksToBounds = true
        attachmentImageView.contentMode = .scaleAspectFill
        attachmentImageView.layer.cornerRadius = 3
        attachmentImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ConversationMessageTableViewCell.imagePressed))
        attachmentImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupForMessage(message: Message, showHeader: Bool, configuration: Embed?){
        self.message = message
        self.configuration = configuration
        setupHeader(message: message, show: showHeader)
        setStyle()
        setupForAttachments(message: message)
        setupForOfferMeeting(message: message)
        
    }
    
    func setupHeader(message: Message, show: Bool){
        if show {
            headerTitleLabel.text = dateFormatter.headerStringFromDate(message.createdAt)
            headerHeightLayoutConstraint.constant = 42
            headerView.isHidden = false
        }else{
            headerHeightLayoutConstraint.constant = 0
            headerView.isHidden = true
        }
    }
    
    func setupForOfferMeeting(message: Message) {
        
        if let offerMeetingUser = message.presentSchedule {
            scheduleMeetingHeightConstraint.constant = 140
            scheduleMeetingBorderView.isHidden = false
            scheduleMeetingAvatarView.imageView.image = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
            scheduleMeetingLabel.text = "Schedule Meeting"
            
            UserManager.sharedInstance.userMetaDataForUserId(offerMeetingUser, completion: { (user) in
                
                if let user = user {
                    self.scheduleMeetingAvatarView.setupForUser(user: user)
                    
                    if let creatorName =  user.name {
                        self.scheduleMeetingLabel.text = "Schedule a meeting with \(creatorName)"
                    }
                }
            })
            
        } else {
            scheduleMeetingHeightConstraint.constant = 0
            scheduleMeetingBorderView.isHidden = true
        }
    }
    
    func setStyle(){
        avatarView.imageView.image = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
        
        if let message = message{
            let textColor: UIColor
            
            switch message.sendStatus{
            case .Sent:
                textColor = .black
                avatarView.alpha = 1.0
                nameLabel.textColor = .black
                timeLabel.textColor = ColorPalette.navyDark
                timeLabel.text = dateFormatter.createdAtStringFromDate(message.createdAt)
            case .Pending:
                textColor = ColorPalette.navyDark
                timeLabel.text = "Sending..."
                timeLabel.textColor = ColorPalette.navyDark
                avatarView.alpha = 0.7
                nameLabel.textColor = ColorPalette.navyDark
            case .Failed:
                nameLabel.textColor = ColorPalette.navyMedium
                textColor = ColorPalette.navyMedium
                timeLabel.text = "Failed to send"
                timeLabel.textColor = ColorPalette.navyMedium
                avatarView.alpha = 0.7
                nameLabel.textColor = ColorPalette.navyDark
            }
            
            messageTextView.textColor = textColor
            
            if let formattedString = message.formattedBody {
                let finalString = NSMutableAttributedString(attributedString: formattedString)
                finalString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, finalString.length))
                
                messageTextView.attributedText = finalString
            } else {
                messageTextView.text = message.body ?? " "
            }

            if let authorId = message.authorId{
                getUser(authorId)
            }
        }
    }
    
    func getUser(_ userId: Int64) {
        if let authorType = message?.authorType , authorType == .User {
            UserManager.sharedInstance.userMetaDataForUserId(userId, completion: { (user) in
                
                if let user = user {
                    self.avatarView.setupForUser(user: user)                    
                    if let creatorName =  user.name {
                        self.nameLabel.text = creatorName
                    }
                }
            })
            
        }else {
            if let endUser = DriftDataStore.sharedInstance.auth?.enduser {
                avatarView.setupForUser(user: endUser)
                            
                if let creatorName = endUser.name {
                    self.nameLabel.text = creatorName
                }else if let email = endUser.email {
                    self.nameLabel.text = email
                }else{
                    self.nameLabel.text = "You"
                }
            }
        }
    }
    
    func setupForAttachmentStyle(attachmentStyle: AttachmentStyle){
        switch attachmentStyle{
        case .multiple:
            singleAttachmentViewHeightConstraint.constant = 0
            multipleAttachmentViewHeightConstraint.constant = 65
            singleAttachmentView.isHidden = true
            multipleAttachmentView.isHidden = false
        case .single, .loading:
            singleAttachmentViewHeightConstraint.constant = 120
            multipleAttachmentViewHeightConstraint.constant = 0
            singleAttachmentView.isHidden = false
            multipleAttachmentView.isHidden = true
        case .none:
            singleAttachmentViewHeightConstraint.constant = 0
            multipleAttachmentViewHeightConstraint.constant = 0
            singleAttachmentView.isHidden = true
            multipleAttachmentView.isHidden = true
        }
    }
    
    func setupForAttachments(message: Message) {
        if message.attachmentIds.isEmpty == .some(true){
            //Hide them all
            setupForAttachmentStyle(attachmentStyle: .none)
        }else{
            if !message.attachments.isEmpty {
                //Attachments are loaded
                displayAttachments(attachments: message.attachments)
            } else {                
                if message.attachmentIds.count == 1 {
                    setupForAttachmentStyle(attachmentStyle: .loading)
                }else{
                    setupForAttachmentStyle(attachmentStyle: .multiple)
                }
                
                DriftAPIManager.getAttachmentsMetaData(message.attachmentIds, authToken: (DriftDataStore.sharedInstance.auth?.accessToken)!, completion: { (result) in
                    switch result{
                    case .success(let attachments):
                        message.attachments.append(contentsOf: attachments)
                        self.displayAttachments(attachments: attachments)
                    case .failure:
                        LoggerManager.log("Failed to get attachment metadata for message: \(message.id)")
                    }
                })
            }
        }
    }
    
    func displayAttachments(attachments: [Attachment]) {
        if attachments.count == 1 {
            //Single Attachments
            
            let attachment = attachments.first!
            
            if attachment.isImage(){
                let placeholder = UIImage(named: "imagePlaceholder", in: Bundle(for: Drift.self), compatibleWith: nil)

                self.setupForAttachmentStyle(attachmentStyle: .single)
                if let urlRequest = attachment.getAttachmentURL(accessToken: DriftDataStore.sharedInstance.auth?.accessToken) {
                    self.attachmentImageView.af_setImage(withURLRequest: urlRequest, placeholderImage: placeholder)
                } else {
                    self.attachmentImageView.image = placeholder
                }
            }else{
                self.setupForAttachmentStyle(attachmentStyle: .multiple)
            }
            
        } else {
            //Multiple Attachments
            self.setupForAttachmentStyle(attachmentStyle: .multiple)
        }
        
        attachmentsCollectionView.reloadData()
    }
    
    @objc func imagePressed(){
        if let attachment = message?.attachments.first{
            delegate?.attachmentSelected(attachment, sender: self)
        }
    }
    
    func setTimeLabel(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeLabel.textColor = ColorPalette.navyDark
        timeLabel.text = formatter.string(from: date)
    }
    
    func setUser(name: String?, email: String?){
        if name == nil && email == nil{
            nameLabel.text = "Site Visitor"
        }else{
            nameLabel.text = name == nil ? email : name
        }
    }
    
    @IBAction func schedulePressed() {
        if let scheduleUserId = message?.presentSchedule {
            delegate?.presentScheduleOfferingForUserId(userId: scheduleUserId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCollectionViewCell", for: indexPath) as! AttachmentCollectionViewCell
        cell.layer.cornerRadius = 3.0
        
        if let attachment = message?.attachments[indexPath.row] {
            let fileName: NSString = attachment.fileName as NSString
            let fileExtension = fileName.pathExtension
            cell.fileNameLabel.text = "\(fileName)"
            cell.fileExtensionLabel.text = "\(fileExtension.uppercased())"
            
            let formatter = ByteCountFormatter()
            formatter.countStyle = .memory
            formatter.string(fromByteCount: Int64(attachment.size))
            formatter.allowsNonnumericFormatting = false
            cell.sizeLabel.text = formatter.string(fromByteCount: Int64(attachment.size))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = message?.attachments.count ?? 0
        if count == 1 {
            if message!.attachments[0].isImage(){
                return 0
            }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.attachmentSelected(message!.attachments[indexPath.row], sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let attachments = message?.attachments {
            if let attachment = attachments.first, attachments.count == 1, attachment.isImage(){
                return CGSize(width: 0, height: 0)
            }
            return CGSize(width: 200, height: 55)
        }
        return CGSize(width: 0, height: 0)
    }
}
