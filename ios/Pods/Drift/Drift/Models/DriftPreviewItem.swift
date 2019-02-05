//
//  DriftPreviewItem.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 02/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit
import QuickLook

class DriftPreviewItem: NSObject, QLPreviewItem{
    var previewItemURL: URL?
    var previewItemTitle: String?
    
    init(url: URL, title: String){
        self.previewItemURL = url
        self.previewItemTitle = title
    }
}
