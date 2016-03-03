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

@objc class LearnView: WordView {
    override func layout() {
        var y = self.layoutLabel(self.japaneseLabel!, atY: 0)
        y = self.layoutLabel(self.partOfSpeechLabel!, atY: y)
        y = self.layoutLabel(self.kanaLabel!, atY: y)
        y = self.layoutLabel(self.chineseLabel!, atY: y)
        
        var f = self.speakButton!.frame
        f.origin.y = self.partOfSpeechLabel!.frame.origin.y
        self.speakButton!.frame = f
        
        var frame = self.frame
        frame.size.height = self.chineseLabel!.frame.origin.y + self.chineseLabel!.frame.size.height
        self.frame = frame
    }
}