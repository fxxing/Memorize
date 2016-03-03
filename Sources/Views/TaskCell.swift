//
//  TaskCell.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

@objc class TaskCell: SWTableViewCell {
    @IBOutlet var countLabel: UILabel?
    @IBOutlet var taskLabel: UILabel?
    
    var index: Int?
    
    override func awakeFromNib() {
        self.countLabel!.layer.cornerRadius = self.countLabel!.frame.size.width / 2
        self.countLabel!.clipsToBounds = true
    }
}