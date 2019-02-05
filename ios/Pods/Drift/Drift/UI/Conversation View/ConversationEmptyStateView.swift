//
//  ConversationEmptyStateView.swift
//  Drift
//
//  Created by Brian McDonald on 16/08/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import UIKit

class ConversationEmptyStateView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageLabel.clipsToBounds = true
        self.messageLabel.layer.cornerRadius = 3.0
        
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = 3.0
    }

}
