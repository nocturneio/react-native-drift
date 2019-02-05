//
//  ScheduleMeetingViewController.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 05/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ScheduleMeetingViewControllerDelegate: class {
    func didDismissScheduleVC()
}

class ScheduleMeetingViewController: UIViewController {

    enum ScheduleMode {
        case day
        case time(date: Date)
        case confirm(date: Date)
    }
    
    @IBOutlet var scheduleTableView: UITableView! {
        didSet{
            scheduleTableView.isHidden = true
        }
    }
    @IBOutlet var containerView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var confirmationView: UIView! {
        didSet{
            confirmationView.isHidden = true
        }
    }
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var topHeaderContainerView: UIView!
    @IBOutlet var meetingDurationLabel: UILabel!{
        didSet{
            meetingDurationLabel.text = ""
        }
    }
    @IBOutlet var confirmationTimeLabel: UILabel!
    @IBOutlet var confirmationDateLabel: UILabel!
    @IBOutlet var confirmationTimeZoneLabel: UILabel!
    @IBOutlet var scheduleButton: UIButton! {
        didSet{
            scheduleButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet var backButton: UIButton! {
        didSet{
            backButton.isHidden = true
            backButton.tintColor = DriftDataStore.sharedInstance.generateBackgroundColor()
        }
    }
    
    @IBOutlet var userAvatarView: AvatarView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var selectDateLabel: UILabel!
    
    
    var scheduleMode: ScheduleMode = .day
    var userAvailability: UserAvailability?
    
    var userId: Int64!
    var conversationId: Int!

    weak var delegate: ScheduleMeetingViewControllerDelegate?
    
    var days: [Date] = []
    var times: [Date] = []
    
    convenience init(userId: Int64, conversationId: Int, delegate: ScheduleMeetingViewControllerDelegate) {
        self.init(nibName: "ScheduleMeetingViewController", bundle: Bundle(for: ScheduleMeetingViewController.classForCoder()))
        self.userId = userId
        self.conversationId = conversationId
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDismissScheduleVC)))
        
        
        topHeaderContainerView.backgroundColor = DriftDataStore.sharedInstance.generateBackgroundColor()
        
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = true
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.cornerRadius = 6
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.tableFooterView = UIView()
        
        updateForUserId(userId: userId)
    }
    
    @objc func didDismissScheduleVC(){
        delegate?.didDismissScheduleVC()
    }
    
    func updateForUserId(userId: Int64) {
        self.userId = userId
        SVProgressHUD.show()
        DriftAPIManager.getUserAvailability(userId) { [weak self] (result) in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let userAvailability):
                self?.userAvailability = userAvailability
                self?.setupForUserAvailability()
                self?.updateForMode(userAvailability: userAvailability)
            case .failure(_):
                self?.showAPIError()
            }
        }
        
        userAvatarView.imageView.image = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
        userNameLabel.text = ""
        UserManager.sharedInstance.userMetaDataForUserId(userId, completion: { (user) in
            
            if let user = user {
                self.userAvatarView.setupForUser(user: user)

                if let creatorName =  user.name {
                    self.userNameLabel.text = creatorName
                }
            }
        })
        
    }
    
    func setupForUserAvailability() {
        
        guard let userAvailability = userAvailability else {
            return
        }
        
        if let duration = userAvailability.duration {
            meetingDurationLabel.text = "\(duration) minutes"
        } else {
            meetingDurationLabel.text = ""
        }
        
        
        
    }
    
    @IBAction func backButtonPressed() {
        
        guard let userAvailability = userAvailability else {
            return
        }
        
        switch scheduleMode {
        case .day:
            ()
        case .time(_):
            self.scheduleMode = .day
        case .confirm(let date):
            //hide table view
            self.scheduleMode = .time(date: date)
        }
        
        updateForMode(userAvailability: userAvailability)
        
    }
    
    @IBAction func schedulePressed() {
        
        guard case let .confirm(date) = scheduleMode, let userAvailability = userAvailability else {
            return
        }
        
        SVProgressHUD.show()
        DriftAPIManager.scheduleMeeting(userId, conversationId: conversationId, timestamp: date.timeIntervalSince1970*1000) { [weak self] (result) in
            
            switch result {
            case .success(let googleMeeting):
                self?.postMeetingInfo(googleMeeting, userAvailability: userAvailability, slotDate: date)
            case .failure(_):
                self?.scheduleMeetingError()
            }
        }
    }
    
    func postMeetingInfo(_ googleMeeting: GoogleMeeting, userAvailability: UserAvailability, slotDate: Date) {
        
        let messageRequest = MessageRequest(googleMeeting: googleMeeting, userAvailability: userAvailability, meetingUserId: userId, conversationId: conversationId, timeSlot: slotDate)
        DriftAPIManager.postMessage(conversationId, messageRequest: messageRequest) { [weak self] (result) in
            SVProgressHUD.dismiss()
 
            switch (result) {
            case .success(_):
                self?.delegate?.didDismissScheduleVC()
            case .failure(_):
                
                self?.scheduleMeetingError()
            }
        }
    }
    
    
    func scheduleMeetingError(){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: "Failed to schedule meeting", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] (_) in
            self?.schedulePressed()
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func showAPIError(){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: "Failed to get calendar information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func updateForMode(userAvailability: UserAvailability){
     
        switch scheduleMode {
        case .day:
            days = userAvailability.slotsForDays()
            scheduleTableView.reloadData()
            scheduleTableView.isHidden = false
            confirmationView.isHidden = true
            backButton.isHidden = true
            selectDateLabel.text = "Select a Day"
            //show tableview
        case .time(let day):
            //show tableview
            //show back
            times = userAvailability.slotsForDay(date: day)
            scheduleTableView.reloadData()
            scheduleTableView.isHidden = false
            confirmationView.isHidden = true
            backButton.isHidden = false
            selectDateLabel.text = "Select a Time"
        case .confirm(let date):
            //hide table view
            scheduleTableView.isHidden = true
            confirmationView.isHidden = false
            backButton.isHidden = false
            selectDateLabel.text = ""
            
            
            let startTime = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)

            let endDate = date.addingTimeInterval(TimeInterval((userAvailability.duration ?? 0) * 60))
            
            let endTime = DateFormatter.localizedString(from: endDate, dateStyle: .none, timeStyle: .short)
            
            confirmationTimeLabel.text = "\(startTime) - \(endTime)"
            confirmationDateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            confirmationTimeZoneLabel.text = TimeZone.current.identifier
        }
        
    }
}

extension ScheduleMeetingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch scheduleMode {
        case .day:
            scheduleMode = .time(date: days[indexPath.row])
        case .time(_):
            scheduleMode = .confirm(date: times[indexPath.row])
        default:
            ()
        }
        
        if let userAvailability = userAvailability {
            updateForMode(userAvailability: userAvailability)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch scheduleMode {
        case .day:
            return days.count
        case .time(_):
            return times.count
        case .confirm(_):
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)!
        
        switch scheduleMode {
        case .day:
            let date = days[indexPath.row]
            cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        case .time(_):
            let date = times[indexPath.row]
            cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        case .confirm(_):
            ()
        }
        
        return cell
    }
    
}
