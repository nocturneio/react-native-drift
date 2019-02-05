//
//  ConnectionBarView.swift
//  Drift
//
//  Created by Brian McDonald on 16/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import UIKit

class ConnectionBarView: UIView {

    @IBOutlet weak var connectionStatusLabel: UILabel! {
        didSet{
            connectionStatusLabel.font = UIFont(name: "Avenir-Book", size: 14)
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = ColorPalette.driftGreen
        connectionStatusLabel.isHidden = true
    }
    
    func didUpdateStatus(status: ConnectionStatus){
        connectionStatusLabel.isHidden = false

        switch status {
        case .connected:
            connectionStatusLabel.text = "Connected"
            backgroundColor = ColorPalette.driftGreen
        case .connecting:
            connectionStatusLabel.text = "Connecting"
            backgroundColor = ColorPalette.driftBlue
        case .disconnected:
            connectionStatusLabel.text = "Disconnected"
            backgroundColor = .red
        }
    }
    
}
