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

@objc class DictateView: WordView {
    @IBOutlet var showAnswerButton: UIButton?
    override func layout() {
        self.japaneseLabel!.hidden = !self.answerShown
        self.partOfSpeechLabel!.hidden = !self.answerShown
        self.kanaLabel!.hidden = !self.answerShown
        self.chineseLabel!.hidden = !self.answerShown
        self.showAnswerButton!.hidden = self.answerShown
        
        var y: CGFloat = self.speakButton!.frame.origin.y + self.speakButton!.frame.size.height + WordView.SPACING
        var frame = self.frame
        if self.answerShown {
            y = self.layoutLabel(self.japaneseLabel!, atY: y)
            y = self.layoutLabel(self.kanaLabel!, atY: y)
            y = self.layoutLabel(self.partOfSpeechLabel!, atY: y)
            y = self.layoutLabel(self.chineseLabel!, atY: y)
            
            frame.size.height = self.chineseLabel!.frame.origin.y + self.chineseLabel!.frame.size.height
        } else {
            var f = self.showAnswerButton!.frame
            f.origin.y = y
            self.showAnswerButton!.frame = f
            
            frame.size.height = f.origin.y + f.size.height
        }
        self.frame = frame
    }
    
    override func didSetWord() {
        self.speak()
    }
}