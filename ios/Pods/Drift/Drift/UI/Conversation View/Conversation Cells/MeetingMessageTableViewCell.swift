//
//  MeetingMessageTableViewCell.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 08/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit

class MeetingMessageTableViewCell: UITableViewCell {
    
    lazy var meetingFormatter = DriftDateFormatter()
    
    lazy var dateFormatter: DateFormatter = {
        
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: MessageTableHeaderView!
    
    
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet{
            timeLabel.textColor = ColorPalette.navyExtraDark
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet{
            dateLabel.textColor = ColorPalette.navyExtraDark
        }
    }
    
    @IBOutlet weak var timezoneLabel: UILabel! {
        didSet{
            timezoneLabel.textColor = ColorPalette.navyExtraDark
        }
    }
    
    
    @IBOutlet weak var scheduleTitleLabel: UILabel! {
        didSet{
            scheduleTitleLabel.textColor = ColorPalette.navyExtraDark
        }
    }
    @IBOutlet weak var scheduleMeetingAvatarView: AvatarView!
    
    @IBOutlet var borderView: UIView! {
        didSet{
            borderView.layer.cornerRadius = 3
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = ColorPalette.navyMedium.cgColor
        }
    }
    
    
    func setupForAppointmentInformation(appointmentInformation: AppointmentInformation, message: Message, showHeader: Bool) {
        
        setupHeader(message: message, show: showHeader)
        
        let startDate = appointmentInformation.availabilitySlot
        let endDate = startDate.addingTimeInterval(TimeInterval(appointmentInformation.slotDuration * 60))
        
        
        let timeZone = TimeZone(identifier: appointmentInformation.agentTimeZone ?? "") ?? TimeZone.current
        
        dateFormatter.timeZone = timeZone
        
        timeLabel.text = dateFormatter.string(from: startDate) + "-" + dateFormatter.string(from: endDate)
        dateLabel.text = meetingFormatter.dateFormatForMeetings(date: startDate)
        timezoneLabel.text = appointmentInformation.agentTimeZone ?? ""
        
        scheduleMeetingAvatarView.imageView.image = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
        
        UserManager.sharedInstance.userMetaDataForUserId(appointmentInformation.agentId, completion: { [weak self] (user) in
            
            if let user = user {
                self?.scheduleMeetingAvatarView.setupForUser(user: user)
                self?.scheduleTitleLabel.text = "Scheduled a Meeting with " + user.getUserName()
            }else{
                self?.scheduleTitleLabel.text = "Scheduled Meeting"
            }
        })
        
        
        
    }
    
    
    
    func setupHeader(message: Message, show: Bool){
        
        if show {
            headerTitleLabel.text = meetingFormatter.headerStringFromDate(message.createdAt)
            headerHeightLayoutConstraint.constant = 42
            headerView.isHidden = false
        }else{
            headerHeightLayoutConstraint.constant = 0
            headerView.isHidden = true
        }
    }
    
}

